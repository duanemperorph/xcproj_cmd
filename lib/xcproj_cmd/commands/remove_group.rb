module XcprojCmd
  module Commands
    class RemoveGroup < Base
      def execute(group_path)
        info "Removing group: #{group_path}"
        
        manager.remove_group(group_path)
        
        save_project
        success "Group removed: #{group_path}"
      end
    end
  end
end

