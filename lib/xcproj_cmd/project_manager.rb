module XcprojCmd
  class ProjectManager
    attr_reader :project, :project_path
    
    def initialize(project_path)
      @project_path = project_path
      @project = Xcodeproj::Project.open(project_path)
    rescue => e
      raise ProjectNotFoundError, "Could not open project: #{e.message}"
    end
    
    def save
      project.save
    end
    
    # Find a group by path (e.g., "MyApp/Controllers/Auth")
    def find_group(path)
      parts = path.split('/')
      current = project.main_group
      
      parts.each do |part|
        current = current.groups.find { |g| g.display_name == part || g.name == part }
        return nil unless current
      end
      
      current
    end
    
    # Find a file reference by name or path
    def find_file(name_or_path)
      project.files.find do |file|
        file.display_name == name_or_path || 
        file.real_path.to_s.end_with?(name_or_path)
      end
    end
    
    # Get all targets or filter by names
    def targets(names = nil)
      return project.targets if names.nil? || names.empty?
      
      project.targets.select { |t| names.include?(t.name) }
    end
    
    # Recursively print group structure
    def print_tree(group = project.main_group, indent = 0, show_targets: false)
      output = []
      prefix = "  " * indent
      
      group.children.sort_by(&:display_name).each do |child|
        if child.is_a?(Xcodeproj::Project::Object::PBXGroup)
          output << "#{prefix}📁 #{child.display_name}/"
          output += print_tree(child, indent + 1, show_targets: show_targets)
        else
          icon = file_icon(child)
          line = "#{prefix}#{icon} #{child.display_name}"
          
          if show_targets
            target_names = file_targets(child).map(&:name).join(', ')
            line += " [#{target_names}]" unless target_names.empty?
          end
          
          output << line
        end
      end
      
      output
    end
    
    # Add file to project
    def add_file(file_path, group:, targets: [])
      target_group = group ? find_group(group) : project.main_group
      raise GroupNotFoundError, "Group not found: #{group}" unless target_group
      
      # Convert to absolute path to avoid path resolution issues with xcodeproj gem
      absolute_path = File.absolute_path(file_path)
      
      file_ref = target_group.new_file(absolute_path)
      
      # Add to targets
      targets(targets).each do |target|
        target.add_file_references([file_ref]) if should_add_to_target?(file_ref, target)
      end
      
      file_ref
    end
    
    # Remove file from project
    def remove_file(name_or_path)
      file_ref = find_file(name_or_path)
      raise FileNotFoundError, "File not found: #{name_or_path}" unless file_ref
      
      # Remove from all targets
      project.targets.each do |target|
        target.source_build_phase.remove_file_reference(file_ref)
        target.resources_build_phase&.remove_file_reference(file_ref)
      end
      
      # Remove reference
      file_ref.remove_from_project
    end
    
    # Add group
    def add_group(path)
      parts = path.split('/')
      current = project.main_group
      
      parts.each do |part|
        existing = current.groups.find { |g| g.display_name == part }
        
        if existing
          current = existing
        else
          current = current.new_group(part)
        end
      end
      
      current
    end
    
    # Remove group
    def remove_group(path)
      group = find_group(path)
      raise GroupNotFoundError, "Group not found: #{path}" unless group
      
      # Remove the group from the project
      group.remove_from_project
    end
    
    # Get file or group info
    def get_info(path)
      # Try to find as file first
      file_ref = find_file(path)
      return file_info(file_ref) if file_ref
      
      # Try as group
      group = find_group(path)
      return group_info(group) if group
      
      raise Error, "File or group not found: #{path}"
    end
    
    private
    
    def project_dir
      File.dirname(project_path)
    end
    
    def file_icon(file_ref)
      case file_ref.last_known_file_type
      when 'sourcecode.swift' then '🔷'
      when /^sourcecode\.c/ then '📘'
      when /^sourcecode\.objc/ then '📙'
      when 'text.plist.xml' then '📋'
      when /^image/ then '🖼️ '
      when 'folder.assetcatalog' then '🎨'
      else '📄'
      end
    end
    
    def file_targets(file_ref)
      project.targets.select do |target|
        target.source_build_phase.files_references.include?(file_ref) ||
        target.resources_build_phase&.files_references&.include?(file_ref)
      end
    end
    
    def should_add_to_target?(file_ref, target)
      # Logic to determine if file should be added to build phase
      case file_ref.last_known_file_type
      when /^sourcecode/, 'text.script'
        true
      else
        false
      end
    end
    
    def file_info(file_ref)
      {
        type: :file,
        name: file_ref.display_name,
        file_type: file_ref.last_known_file_type,
        path: file_ref.real_path&.to_s,
        exists: file_ref.real_path&.exist? || false,
        targets: file_targets(file_ref).map(&:name)
      }
    end
    
    def group_info(group)
      children = group.children.map(&:display_name)
      {
        type: :group,
        name: group.display_name,
        path: group.real_path&.to_s,
        children: children,
        children_count: children.size
      }
    end
  end
end

