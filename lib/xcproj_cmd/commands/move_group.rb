module XcprojCmd
  module Commands
    class MoveGroup < Base
      def execute(group_path, target_group_path)
        info "Moving group: #{group_path}"
        info "  To group: #{target_group_path}"
        
        manager.move_group(group_path, target_group_path)
        
        save_project
        success "Group moved: #{group_path} → #{target_group_path}"
      end
    end
  end
end

