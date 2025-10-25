module XcprojCmd
  module Commands
    class AddFile < Base
      def execute(file_path)
        unless File.exist?(file_path)
          error "File does not exist: #{file_path}"
          return
        end
        
        group_path = options[:group]
        target_names = options[:targets] || []
        
        info "Adding file: #{file_path}"
        info "  Group: #{group_path || '(root)'}"
        info "  Targets: #{target_names.join(', ')}" unless target_names.empty?
        
        begin
          manager.add_file(
            file_path,
            group: group_path,
            targets: target_names
          )
          
          save_project
          success "File added: #{File.basename(file_path)}"
        rescue GroupNotFoundError => e
          if options[:create_groups]
            info "Creating group: #{group_path}"
            manager.add_group(group_path)
            retry
          else
            error e.message
            info "Use --create-groups to automatically create missing groups"
          end
        end
      end
    end
  end
end

