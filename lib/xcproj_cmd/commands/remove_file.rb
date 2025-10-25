module XcprojCmd
  module Commands
    class RemoveFile < Base
      def execute(file_path)
        delete_from_disk = options[:delete]
        
        info "Removing file: #{file_path}"
        info "  Delete from disk: #{delete_from_disk ? 'Yes' : 'No'}"
        
        manager.remove_file(file_path, delete_from_disk: delete_from_disk)
        
        save_project
        success "File removed: #{file_path}"
        success "Deleted from disk" if delete_from_disk
      end
    end
  end
end

