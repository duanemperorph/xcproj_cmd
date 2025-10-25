module XcprojCmd
  class CLI < Thor
    class_option :project, 
                 type: :string, 
                 aliases: '-p',
                 desc: 'Path to .xcodeproj file'
    
    desc "list", "Show project structure"
    method_option :format, 
                  type: :string, 
                  default: 'tree',
                  enum: ['tree', 'flat', 'json'],
                  desc: 'Output format'
    method_option :targets,
                  type: :boolean,
                  default: false,
                  desc: 'Show target membership'
    def list
      Commands::List.new(project_path, options).execute
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "add PATH", "Add a file to the project"
    method_option :group,
                  type: :string,
                  aliases: '-g',
                  desc: 'Group path to add file to'
    method_option :targets,
                  type: :array,
                  aliases: '-t',
                  desc: 'Targets to add file to'
    method_option :create_groups,
                  type: :boolean,
                  default: false,
                  desc: 'Create parent groups if they don\'t exist'
    def add(path)
      Commands::AddFile.new(project_path, options).execute(path)
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "remove PATH", "Remove a file from the project"
    method_option :delete,
                  type: :boolean,
                  default: false,
                  desc: 'Also delete file from filesystem'
    def remove(path)
      Commands::RemoveFile.new(project_path, options).execute(path)
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "add_group PATH", "Create a group"
    method_option :create_folder,
                  type: :boolean,
                  default: false,
                  desc: 'Create physical folder on disk'
    def add_group(path)
      Commands::AddGroup.new(project_path, options).execute(path)
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "remove_group PATH", "Remove a group"
    method_option :delete_folder,
                  type: :boolean,
                  default: false,
                  desc: 'Also delete physical folder from disk'
    def remove_group(path)
      Commands::RemoveGroup.new(project_path, options).execute(path)
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "move FILE TARGET_GROUP", "Move a file to a different group"
    method_option :group,
                  type: :boolean,
                  default: false,
                  desc: 'Move a group instead of a file'
    def move(source, target)
      if options[:group]
        Commands::MoveGroup.new(project_path, options).execute(source, target)
      else
        Commands::MoveFile.new(project_path, options).execute(source, target)
      end
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "info PATH", "Show detailed information about a file or group"
    method_option :json,
                  type: :boolean,
                  default: false,
                  desc: 'Output as JSON'
    def info(path)
      Commands::Info.new(project_path, options).execute(path)
    rescue Error => e
      puts "Error: #{e.message}".red
      exit 1
    end
    
    desc "version", "Show version"
    def version
      puts "xcproj v#{VERSION}"
    end
    
    private
    
    def project_path
      options[:project] || find_project_in_current_dir
    end
    
    def find_project_in_current_dir
      projects = Dir.glob('*.xcodeproj')
      
      if projects.empty?
        raise Error, "No .xcodeproj found in current directory. Use --project to specify path."
      elsif projects.size > 1
        raise Error, "Multiple .xcodeproj files found. Use --project to specify which one."
      end
      
      projects.first
    end
  end
end

