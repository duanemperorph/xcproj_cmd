module XcprojCmd
  module Commands
    class Base
      attr_reader :project_path, :options, :manager
      
      def initialize(project_path, options = {})
        @project_path = project_path
        @options = options
        @manager = ProjectManager.new(project_path)
      end
      
      def execute
        raise NotImplementedError, "Subclasses must implement execute method"
      end
      
      protected
      
      def success(message)
        puts "✓ #{message}".green
      end
      
      def error(message)
        puts "✗ #{message}".red
      end
      
      def info(message)
        puts "ℹ #{message}".blue
      end
      
      def save_project
        manager.save
        success "Project saved"
      end
    end
  end
end

