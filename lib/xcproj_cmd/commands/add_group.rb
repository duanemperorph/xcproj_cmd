module XcprojCmd
  module Commands
    class AddGroup < Base
      def execute(group_path)
        create_folder = options[:create_folder]
        
        info "Creating group: #{group_path}"
        info "  Create folder: #{create_folder ? 'Yes' : 'No'}"
        
        manager.add_group(group_path, create_folder: create_folder)
        
        save_project
        success "Group created: #{group_path}"
        success "Folder created on disk" if create_folder
      end
    end
  end
end

