module XcprojCmd
  module Commands
    class RemoveGroup < Base
      def execute(group_path)
        delete_folder = options[:delete_folder]
        
        info "Removing group: #{group_path}"
        info "  Delete folder: #{delete_folder ? 'Yes' : 'No'}"
        
        manager.remove_group(group_path, delete_folder: delete_folder)
        
        save_project
        success "Group removed: #{group_path}"
        success "Folder deleted from disk" if delete_folder
      end
    end
  end
end

