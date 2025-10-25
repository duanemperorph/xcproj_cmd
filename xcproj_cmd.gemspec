require_relative 'lib/xcproj_cmd/version'

Gem::Specification.new do |spec|
  spec.name          = "xcproj_cmd"
  spec.version       = XcprojCmd::VERSION
  spec.authors       = ["Lucas Nguyen"]
  spec.email         = ["your.email@example.com"]
  
  spec.summary       = "Command-line tool for managing Xcode projects"
  spec.description   = "A CLI wrapper around xcodeproj gem for managing files and groups in Xcode projects"
  spec.homepage      = "https://github.com/yourusername/xcproj_cmd"
  spec.license       = "MIT"
  
  spec.files         = Dir["lib/**/*", "bin/*"]
  spec.bindir        = "bin"
  spec.executables   = ["xcproj"]
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = ">= 2.6.0"
  
  spec.add_dependency "xcodeproj", "~> 1.23"
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "colorize", "~> 1.1"
end

