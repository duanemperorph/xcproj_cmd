require 'xcodeproj'
require 'thor'
require 'colorize'

module XcprojCmd
  class Error < StandardError; end
  class ProjectNotFoundError < Error; end
  class FileNotFoundError < Error; end
  class GroupNotFoundError < Error; end
end

require_relative 'xcproj_cmd/version'
require_relative 'xcproj_cmd/project_manager'
require_relative 'xcproj_cmd/commands/base'
require_relative 'xcproj_cmd/commands/list'
require_relative 'xcproj_cmd/commands/add_file'
require_relative 'xcproj_cmd/commands/remove_file'
require_relative 'xcproj_cmd/commands/add_group'
require_relative 'xcproj_cmd/commands/remove_group'
require_relative 'xcproj_cmd/commands/move_file'
require_relative 'xcproj_cmd/commands/move_group'
require_relative 'xcproj_cmd/commands/info'
require_relative 'xcproj_cmd/cli'

