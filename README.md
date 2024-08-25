# Unity Git Setup Script

A bash script to set up a Git repository for Unity projects with appropriate configurations.

## What it does

1. Initializes a Git repository
2. Creates a Unity-specific `.gitignore`
3. Sets up `.gitattributes` for Git LFS and Unity file handling
4. Configures Git to use UnityYAMLMerge for Unity asset files
5. Makes an initial commit with these configurations

## Usage

1. Clone this repository:
   ```
   git clone https://github.com/bratorange/Init-Unity-Git.git
   ```
2. Clone this repository:
   ```
   cd Init-Unity-Git
   ```
3. Make the script executable:
   ```
   chmod +x setup_unity_git.sh
   ```
4. Run the script, specifying your Unity project path:
   ```
   ./setup_unity_git.sh /path/to/your/unity/project
   ```

## Requirements

- Git
- Bash shell (use Git Bash on Windows)
- Unity installation (for UnityYAMLMerge tool)

## Sources

- [Unity Smart Merge Documentation](https://docs.unity3d.com/Manual/SmartMerge.html)
- [Git LFS .gitattributes for Unity](https://gist.github.com/Srfigie/77b5c15bc5eb61733a74d34d10b3ed87)
- [Unity .gitignore Template](https://www.toptal.com/developers/gitignore/api/unity)
