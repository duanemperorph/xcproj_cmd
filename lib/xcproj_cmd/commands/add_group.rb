module XcprojCmd
  module Commands
    class AddGroup < Base
      def execute(group_path)
        info "Creating group: #{group_path}"
        
        manager.add_group(group_path)
        
        save_project
        success "Group created: #{group_path}"
      end
    end
  end
end

