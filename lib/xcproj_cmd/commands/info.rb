require 'json'

module XcprojCmd
  module Commands
    class Info < Base
      def execute(path)
        info_data = manager.get_info(path)
        
        if options[:json]
          puts JSON.pretty_generate(info_data)
        else
          print_formatted_info(info_data)
        end
      end
      
      private
      
      def print_formatted_info(info_data)
        if info_data[:type] == :file
          print_file_info(info_data)
        else
          print_group_info(info_data)
        end
      end
      
      def print_file_info(info)
        puts "File: #{info[:name]}".bold
        puts "Type: #{info[:file_type]}"
        puts "Path: #{info[:path]}"
        puts "Exists on disk: #{info[:exists] ? '✓ Yes'.green : '✗ No'.red}"
        puts
        puts "Targets:".bold
        if info[:targets].empty?
          puts "  (none)"
        else
          info[:targets].each do |target|
            puts "  ✓ #{target}".green
          end
        end
      end
      
      def print_group_info(info)
        puts "Group: #{info[:name]}".bold
        puts "Path: #{info[:path]}" if info[:path]
        puts "Children: #{info[:children_count]}"
        puts
        puts "Contents:".bold
        if info[:children].empty?
          puts "  (empty)"
        else
          info[:children].each do |child|
            puts "  - #{child}"
          end
        end
      end
    end
  end
end

