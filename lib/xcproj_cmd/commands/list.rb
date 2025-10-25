require 'json'

module XcprojCmd
  module Commands
    class List < Base
      def execute
        case options[:format]
        when 'tree'
          print_tree_format
        when 'flat'
          print_flat_format
        when 'json'
          print_json_format
        else
          print_tree_format
        end
      end
      
      private
      
      def print_tree_format
        puts "Project: #{manager.project.root_object.name}".bold
        puts
        
        output = manager.print_tree(
          manager.project.main_group,
          0,
          show_targets: options[:targets]
        )
        
        puts output.join("\n")
      end
      
      def print_flat_format
        manager.project.files.each do |file|
          puts file.real_path if file.real_path
        end
      end
      
      def print_json_format
        data = {
          project: manager.project.root_object.name,
          files: manager.project.files.map { |f| f.real_path.to_s }.compact
        }
        
        puts JSON.pretty_generate(data)
      end
    end
  end
end

