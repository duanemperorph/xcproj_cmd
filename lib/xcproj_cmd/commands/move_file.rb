module XcprojCmd
  module Commands
    class MoveFile < Base
      def execute(file_name, target_group_path)
        info "Moving file: #{file_name}"
        info "  To group: #{target_group_path}"
        
        manager.move_file(file_name, target_group_path)
        
        save_project
        success "File moved: #{file_name} → #{target_group_path}"
      end
    end
  end
end

