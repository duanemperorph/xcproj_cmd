# xcproj Agent Rules & Quick Reference

## Command Syntax

All commands follow this pattern:
```
xcproj COMMAND [arguments] --project PROJECT.xcodeproj [options]
```

If only one `.xcodeproj` exists in the directory, `--project` can be omitted.

## Available Commands

### 1. list - Show project structure
```bash
xcproj list [--project PATH] [--format tree|flat|json] [--targets]
```

### 2. add - Add file to project
```bash
xcproj add FILE [--project PATH] [--group GROUP_PATH] [--targets TARGET1 TARGET2] [--create-groups]
```

### 3. remove - Remove file from project
```bash
xcproj remove FILE [--project PATH] [--delete]
```

### 4. group - Create a group
```bash
xcproj group GROUP_PATH [--project PATH] [--create-folder]
```

### 5. move - Move file or group
```bash
xcproj move SOURCE DESTINATION [--project PATH] [--group]
```

### 6. info - Show file/group information
```bash
xcproj info PATH [--project PATH] [--json]
```

### 7. version - Show version
```bash
xcproj version
```

## Key Options

- `--project PATH` or `-p PATH` - Specify .xcodeproj file
- `--group PATH` or `-g PATH` - Specify group path (e.g., "MyApp/Controllers/Auth")
- `--targets T1 T2` or `-t T1 T2` - Specify target names
- `--create-groups` - Auto-create missing groups when adding files
- `--create-folder` - Create physical folder when creating group
- `--delete` - Delete file from disk when removing
- `--format tree|flat|json` - Output format for list command
- `--targets` - Show target membership in list output
- `--json` - Output as JSON for info command

## Common Patterns

**Add file to specific group and target:**
```bash
xcproj add path/to/File.swift --project MyApp.xcodeproj --group MyApp/Views --targets MyApp
```

**Create group structure:**
```bash
xcproj group MyApp/Features/Auth --project MyApp.xcodeproj --create-folder
```

**Move file between groups:**
```bash
xcproj move OldFile.swift MyApp/NewLocation --project MyApp.xcodeproj
```

**Remove file and delete from disk:**
```bash
xcproj remove UnusedFile.swift --project MyApp.xcodeproj --delete
```

**Get file information:**
```bash
xcproj info MyFile.swift --project MyApp.xcodeproj
```

**List with target info:**
```bash
xcproj list --project MyApp.xcodeproj --targets
```

**Export structure as JSON:**
```bash
xcproj list --project MyApp.xcodeproj --format json
```

## Group Paths

Group paths use forward slashes: `MyApp/Features/Auth/Views`
- Root group is typically the project name (e.g., "MyApp")
- Nested groups are separated by `/`
- Example: `MyApp/Model/Data` means group "Data" inside "Model" inside "MyApp"

## Target Names

Target names must match exactly as they appear in Xcode.
Common patterns:
- Main app: `MyApp`
- Tests: `MyAppTests`, `MyAppUITests`
- Extensions: `MyAppWidget`, `MyAppWatch`

## Best Practices for Agents

1. **Always verify file exists before adding:**
   ```bash
   [ -f "File.swift" ] && xcproj add "File.swift" --project MyApp.xcodeproj
   ```

2. **Use --create-groups when structure might not exist:**
   ```bash
   xcproj add File.swift --group MyApp/New/Feature --create-groups
   ```

3. **Check current structure before modifications:**
   ```bash
   xcproj list --project MyApp.xcodeproj
   ```

4. **Use JSON format for parsing:**
   ```bash
   xcproj list --format json | jq '.files[]'
   ```

5. **Use flat format to find files:**
   ```bash
   xcproj list --format flat | grep "MyFile.swift"
   ```

## Error Handling

The tool exits with status 1 on errors. Common errors:
- Project not found: Use `--project` to specify path
- Group not found: Use `--create-groups` or create group first
- File not found: Verify file exists before adding
- Multiple projects: Specify which project with `--project`

## Automation Examples

**Add all Swift files from a directory:**
```bash
for file in Sources/*.swift; do
  xcproj add "$file" --project MyApp.xcodeproj --group MyApp/Sources --targets MyApp
done
```

**Create feature module structure:**
```bash
FEATURE="Authentication"
xcproj group "MyApp/Features/$FEATURE" --create-folder
xcproj group "MyApp/Features/$FEATURE/Views" --create-folder
xcproj group "MyApp/Features/$FEATURE/ViewModels" --create-folder
```

**Remove deprecated files:**
```bash
for file in Deprecated*.swift; do
  xcproj remove "$file" --project MyApp.xcodeproj --delete
done
```

## Quick Decision Tree

**Need to add a file?**
→ `xcproj add FILE --group GROUP --targets TARGETS`

**Need to create groups first?**
→ Add `--create-groups` flag OR `xcproj group GROUP_PATH --create-folder`

**Need to move a file?**
→ `xcproj move FILE TARGET_GROUP`

**Need to remove a file?**
→ `xcproj remove FILE` (keeps on disk) or `xcproj remove FILE --delete`

**Need to see structure?**
→ `xcproj list` (tree) or `xcproj list --format flat` (paths)

**Need file details?**
→ `xcproj info FILE` (human) or `xcproj info FILE --json` (machine)

## Exit Codes

- `0` - Success
- `1` - Error (project not found, file not found, invalid arguments, etc.)

