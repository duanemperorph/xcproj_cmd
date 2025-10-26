# xcproj_cmd

A command-line tool for managing Xcode projects. Wraps the xcodeproj gem to provide easy-to-use commands for file and group management.

## Installation

**For development:**
```bash
bundle install
bundle exec rake install
```

## Usage

### Basic Commands

```bash
# Show version
xcproj version

# Get help
xcproj help
xcproj help COMMAND
```

### List Project Structure

```bash
# Show project structure in tree format
xcproj list

# Show with target membership
xcproj list --targets

# Show as flat file list
xcproj list --format flat

# Show as JSON
xcproj list --format json

# Specify project explicitly
xcproj list --project MyApp.xcodeproj
```

### Add Files

```bash
# Add a file to the project root
xcproj add path/to/NewFile.swift

# Add to a specific group
xcproj add path/to/NewFile.swift --group MyApp/Controllers

# Add to specific targets
xcproj add path/to/NewFile.swift --targets MyApp MyAppTests

# Auto-create groups if they don't exist
xcproj add path/to/NewFile.swift --group MyApp/New/Feature --create-groups
```

### Remove Files

```bash
# Remove file reference from project
xcproj remove OldFile.swift
```

**Note:** This only removes the file reference from the Xcode project. Use `rm` to delete files from the filesystem.

### Manage Groups

```bash
# Create a new group
xcproj add_group MyApp/NewFeature

# Remove a group
xcproj remove_group MyApp/OldFeature
```

**Note:** Group commands only manage the Xcode project structure and do not create or delete filesystem folders. Use standard shell commands (`mkdir`, `rm -rf`) to manage filesystem folders separately. This separation ensures you have full control and visibility over filesystem operations.

### Move Files and Groups

```bash
# Move a file to a different group
xcproj move LoginView.swift MyApp/Views/Auth

# Move a group to a different parent
xcproj move MyApp/OldLocation MyApp/NewLocation --group
```

### Get Information

```bash
# Show info about a file
xcproj info LoginViewController.swift

# Show info about a group
xcproj info MyApp/Controllers

# Output as JSON
xcproj info LoginViewController.swift --json
```

## Examples

### Complete Workflow Example

```bash
# List current structure
xcproj list MyApp.xcodeproj

# Create a new feature group
xcproj add_group MyApp/Features/Auth

# Add files to the new group
xcproj add Sources/LoginView.swift --group MyApp/Features/Auth --targets MyApp
xcproj add Sources/SignupView.swift --group MyApp/Features/Auth --targets MyApp

# View the updated structure
xcproj list --targets

# Get info about a specific file
xcproj info LoginView.swift

# Move a file to a different location
xcproj move LoginView.swift MyApp/Views

# Remove old file reference
xcproj remove DeprecatedFile.swift

# Remove a deprecated feature group
xcproj remove_group MyApp/Features/OldFeature
```

## Development

```bash
# Clone and setup
git clone https://github.com/yourusername/xcproj_cmd
cd xcproj_cmd
bundle install

# Run during development (no installation needed)
bundle exec ./bin/xcproj help

# Run tests
bundle exec rspec

# Install locally for testing
bundle exec rake install

# After making changes, reinstall
bundle exec rake install
```

## Project Structure

```
xcproj_cmd/
├── bin/
│   └── xcproj              # CLI executable
├── lib/
│   ├── xcproj_cmd.rb       # Main module
│   └── xcproj_cmd/
│       ├── version.rb
│       ├── cli.rb          # Thor-based CLI
│       ├── project_manager.rb  # xcodeproj wrapper
│       └── commands/       # Individual command implementations
└── spec/                   # Tests
```

## Requirements

- Ruby >= 2.6.0
- xcodeproj gem

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT

