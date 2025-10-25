# xcproj Command Examples

## Quick Reference for Agent/Automation Use

### Basic Project Information

```bash
# Show version
xcproj version

# Get help for all commands
xcproj help

# Get help for specific command
xcproj help list
xcproj help add
xcproj help remove
xcproj help add_group
xcproj help remove_group
xcproj help move
xcproj help info
```

### List Commands

```bash
# List project structure in tree format
xcproj list --project MyApp.xcodeproj

# List with target membership information
xcproj list --project MyApp.xcodeproj --targets

# List as flat file paths
xcproj list --project MyApp.xcodeproj --format flat

# List as JSON (for parsing)
xcproj list --project MyApp.xcodeproj --format json

# Auto-detect project in current directory (if only one .xcodeproj exists)
xcproj list
```

### Add File Commands

```bash
# Add file to project root
xcproj add path/to/NewFile.swift --project MyApp.xcodeproj

# Add file to specific group
xcproj add Sources/LoginView.swift --project MyApp.xcodeproj --group MyApp/Views

# Add file to specific targets
xcproj add Sources/Utils.swift --project MyApp.xcodeproj --targets MyApp MyAppTests

# Add file to group and targets
xcproj add Sources/AuthService.swift --project MyApp.xcodeproj \
  --group MyApp/Services \
  --targets MyApp

# Auto-create groups if they don't exist
xcproj add Sources/NewFeature/Feature.swift --project MyApp.xcodeproj \
  --group MyApp/Features/NewFeature \
  --create-groups

# Add multiple files (use in a script)
for file in *.swift; do
  xcproj add "$file" --project MyApp.xcodeproj --group MyApp/Sources --targets MyApp
done
```

### Remove File Commands

```bash
# Remove file reference (keeps file on disk)
xcproj remove OldFile.swift --project MyApp.xcodeproj

# Remove file reference and delete from disk
xcproj remove DeprecatedFile.swift --project MyApp.xcodeproj --delete

# Remove multiple files (script example)
for file in Deprecated*.swift; do
  xcproj remove "$file" --project MyApp.xcodeproj
done
```

### Add Group Commands

```bash
# Create a new group
xcproj add_group MyApp/Features --project MyApp.xcodeproj

# Create nested group structure
xcproj add_group MyApp/Features/Auth/ViewModels --project MyApp.xcodeproj

# Create group and matching folder on disk
xcproj add_group MyApp/Services --project MyApp.xcodeproj --create-folder

# Create multiple groups (script example)
for feature in Auth Profile Settings; do
  xcproj add_group "MyApp/Features/$feature" --project MyApp.xcodeproj --create-folder
done
```

### Remove Group Commands

```bash
# Remove a group (keeps folder on disk)
xcproj remove_group MyApp/OldFeature --project MyApp.xcodeproj

# Remove group and delete folder from disk
xcproj remove_group MyApp/Services --project MyApp.xcodeproj --delete-folder

# Remove multiple groups (script example)
for feature in Deprecated OldFeature Legacy; do
  xcproj remove_group "MyApp/Features/$feature" --project MyApp.xcodeproj --delete-folder
done
```

### Move Commands

```bash
# Move a file to different group
xcproj move LoginView.swift MyApp/Views/Auth --project MyApp.xcodeproj

# Move a group to different parent
xcproj move MyApp/OldLocation MyApp/NewLocation --project MyApp.xcodeproj --group

# Reorganize files (script example)
xcproj move ViewModel1.swift MyApp/ViewModels --project MyApp.xcodeproj
xcproj move ViewModel2.swift MyApp/ViewModels --project MyApp.xcodeproj
xcproj move Service1.swift MyApp/Services --project MyApp.xcodeproj
```

### Info Commands

```bash
# Get info about a file
xcproj info LoginViewController.swift --project MyApp.xcodeproj

# Get info about a group
xcproj info MyApp/Controllers --project MyApp.xcodeproj

# Get info as JSON (for parsing)
xcproj info LoginViewController.swift --project MyApp.xcodeproj --json

# Get info about file with full group path
xcproj info MyApp/Views/Auth/LoginView.swift --project MyApp.xcodeproj
```

## Common Workflows

### Workflow 1: Create New Feature Structure

```bash
PROJECT="MyApp.xcodeproj"

# Create group structure
xcproj add_group MyApp/Features/Authentication --project $PROJECT --create-folder
xcproj add_group MyApp/Features/Authentication/Views --project $PROJECT --create-folder
xcproj add_group MyApp/Features/Authentication/ViewModels --project $PROJECT --create-folder
xcproj add_group MyApp/Features/Authentication/Services --project $PROJECT --create-folder

# Add files
xcproj add Auth/LoginView.swift --project $PROJECT \
  --group MyApp/Features/Authentication/Views \
  --targets MyApp

xcproj add Auth/LoginViewModel.swift --project $PROJECT \
  --group MyApp/Features/Authentication/ViewModels \
  --targets MyApp

xcproj add Auth/AuthService.swift --project $PROJECT \
  --group MyApp/Features/Authentication/Services \
  --targets MyApp
```

### Workflow 2: Reorganize Existing Files

```bash
PROJECT="MyApp.xcodeproj"

# List current structure
xcproj list --project $PROJECT

# Create new organization structure
xcproj add_group MyApp/NewStructure/Models --project $PROJECT
xcproj add_group MyApp/NewStructure/Views --project $PROJECT
xcproj add_group MyApp/NewStructure/Controllers --project $PROJECT

# Move files to new structure
xcproj move User.swift MyApp/NewStructure/Models --project $PROJECT
xcproj move Product.swift MyApp/NewStructure/Models --project $PROJECT
xcproj move HomeView.swift MyApp/NewStructure/Views --project $PROJECT
```

### Workflow 3: Clean Up Deprecated Files

```bash
PROJECT="MyApp.xcodeproj"

# List all files
xcproj list --project $PROJECT --format flat > all_files.txt

# Remove deprecated files
xcproj remove OldViewController.swift --project $PROJECT --delete
xcproj remove DeprecatedHelper.swift --project $PROJECT --delete
xcproj remove LegacyService.swift --project $PROJECT --delete

# Verify changes
xcproj list --project $PROJECT
```

### Workflow 4: Add Generated Files

```bash
PROJECT="MyApp.xcodeproj"
TARGET="MyApp"

# Generate some files (example)
# swiftgen, mogenerator, etc.

# Add all generated files to project
for file in Generated/*.swift; do
  xcproj add "$file" --project $PROJECT \
    --group MyApp/Generated \
    --targets $TARGET \
    --create-groups
done
```

### Workflow 6: Clean Up Deprecated Groups

```bash
PROJECT="MyApp.xcodeproj"

# List current structure to identify deprecated groups
xcproj list --project $PROJECT --format flat

# Remove deprecated feature groups
xcproj remove_group MyApp/Features/OldFeature --project $PROJECT --delete-folder
xcproj remove_group MyApp/Features/LegacyUI --project $PROJECT --delete-folder
xcproj remove_group MyApp/Services/DeprecatedService --project $PROJECT --delete-folder

# Verify changes
xcproj list --project $PROJECT
```

### Workflow 5: Audit Target Membership

```bash
PROJECT="MyApp.xcodeproj"

# Export structure with target info as JSON
xcproj list --project $PROJECT --format json > project_structure.json

# Check specific files
xcproj info UtilityFile.swift --project $PROJECT
xcproj info TestHelper.swift --project $PROJECT

# View all files with their targets
xcproj list --project $PROJECT --targets
```

## Integration Examples

### Git Hook (pre-commit)

```bash
#!/bin/bash
# .git/hooks/pre-commit

PROJECT="MyApp.xcodeproj"

# Ensure all Swift files in Sources/ are in the project
for file in Sources/**/*.swift; do
  if ! xcproj list --project $PROJECT --format flat | grep -q "$file"; then
    echo "WARNING: $file is not in the Xcode project"
    xcproj add "$file" --project $PROJECT --group MyApp/Sources --targets MyApp
  fi
done
```

### CI/CD Script

```bash
#!/bin/bash
# scripts/verify_project.sh

PROJECT="MyApp.xcodeproj"

echo "Verifying project structure..."

# Export project structure
xcproj list --project $PROJECT --format json > build/project_structure.json

# Check for required files
required_files=("AppDelegate.swift" "Info.plist")
for file in "${required_files[@]}"; do
  if ! xcproj list --project $PROJECT --format flat | grep -q "$file"; then
    echo "ERROR: Required file $file not found in project"
    exit 1
  fi
done

echo "Project structure verified ✓"
```

### Makefile Integration

```makefile
PROJECT = MyApp.xcodeproj

.PHONY: list-project
list-project:
	xcproj list --project $(PROJECT)

.PHONY: add-file
add-file:
	@read -p "Enter file path: " file; \
	read -p "Enter group path: " group; \
	xcproj add $$file --project $(PROJECT) --group $$group --targets MyApp

.PHONY: project-info
project-info:
	xcproj list --project $(PROJECT) --format json

.PHONY: clean-deprecated
clean-deprecated:
	@for file in Deprecated*.swift; do \
		[ -f "$$file" ] && xcproj remove "$$file" --project $(PROJECT) --delete; \
	done
```

## Scripting Tips

### Check if file exists in project

```bash
if xcproj list --project MyApp.xcodeproj --format flat | grep -q "MyFile.swift"; then
  echo "File exists in project"
else
  echo "File not in project"
  xcproj add MyFile.swift --project MyApp.xcodeproj
fi
```

### Parse JSON output

```bash
# Get list of files as JSON
xcproj list --project MyApp.xcodeproj --format json > structure.json

# Parse with jq
cat structure.json | jq '.files[]'
```

### Batch operations with error handling

```bash
PROJECT="MyApp.xcodeproj"
FILES=(File1.swift File2.swift File3.swift)

for file in "${FILES[@]}"; do
  if xcproj add "$file" --project $PROJECT --group MyApp/Sources --targets MyApp; then
    echo "✓ Added $file"
  else
    echo "✗ Failed to add $file"
  fi
done
```

## Environment Variables

```bash
# Set default project to avoid repeating --project flag
export XCPROJ_DEFAULT_PROJECT="MyApp.xcodeproj"

# Then use commands without --project flag
xcproj list
xcproj add NewFile.swift --group MyApp/Sources
```

## Common Patterns

### Pattern: Auto-detect and use project

```bash
# If only one .xcodeproj in directory
xcproj list

# If multiple, specify
xcproj list --project MyApp.xcodeproj
```

### Pattern: Create mirrored structure

```bash
# Mirror filesystem structure in Xcode groups
find Sources -type d | while read dir; do
  group_path="MyApp/${dir#Sources/}"
  xcproj add_group "$group_path" --project MyApp.xcodeproj
done

find Sources -name "*.swift" | while read file; do
  dir=$(dirname "$file")
  group_path="MyApp/${dir#Sources/}"
  xcproj add "$file" --project MyApp.xcodeproj --group "$group_path"
done
```

### Pattern: Conditional operations

```bash
# Only add if file doesn't exist in project
file="NewFile.swift"
if ! xcproj list --format flat | grep -q "$file"; then
  xcproj add "$file" --project MyApp.xcodeproj --targets MyApp
fi
```

