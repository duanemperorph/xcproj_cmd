module XcprojCmd
  module Commands
    class RemoveFile < Base
      def execute(file_path)
        info "Removing file: #{file_path}"
        
        manager.remove_file(file_path)
        
        save_project
        success "File removed: #{file_path}"
      end
    end
  end
end

