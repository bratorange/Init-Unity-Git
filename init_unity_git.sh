#!/bin/bash

# Script to set up a Unity project for Git

# Check if Git is installed
if ! command -v git &> /dev/null
then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

# Function to find UnityYAMLMerge tool
find_unity_yaml_merge() {
    local unity_versions_dir

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        unity_versions_dir="/Applications/Unity/Hub/Editor"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows
        unity_versions_dir="/c/Program Files/Unity/Hub/Editor"
    else
        echo "Unsupported operating system. Please manually set the UnityYAMLMerge path."
        return 1
    fi

    # Find the most recent Unity version
    local latest_version=$(ls -1 "$unity_versions_dir" | sort -V | tail -n 1)

    if [[ -z "$latest_version" ]]; then
        echo "No Unity version found. Please make sure Unity is installed."
        return 1
    fi

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "$unity_versions_dir/$latest_version/Unity.app/Contents/Tools/UnityYAMLMerge"
    else
        echo "$unity_versions_dir/$latest_version/Editor/Data/Tools/UnityYAMLMerge.exe"
    fi
}

# Use the first argument as the repository path
repo_path="$1"

if [[ -z "$repo_path" ]]; then
    echo "Please provide a path for the Unity project repository as the first argument."
    exit 1
fi

# Create directory if it doesn't exist
mkdir -p "$repo_path"

# Change to the repository directory
cd "$repo_path"

# Find UnityYAMLMerge path
unity_yaml_merge_path=$(find_unity_yaml_merge)

if [[ -z "$unity_yaml_merge_path" ]]; then
    echo "Failed to find UnityYAMLMerge. Please set the path manually in the Git configuration."
    exit 1
fi

# Initialize Git repository
git init

# Create .gitignore file for Unity
cat << EOF > .gitignore
# Created by https://www.toptal.com/developers/gitignore/api/unity
# Edit at https://www.toptal.com/developers/gitignore?templates=unity

### Unity ###
# This .gitignore file should be placed at the root of your Unity project directory
#
# Get latest from https://github.com/github/gitignore/blob/main/Unity.gitignore
/[Ll]ibrary/
/[Tt]emp/
/[Oo]bj/
/[Bb]uild/
/[Bb]uilds/
/[Ll]ogs/
/[Uu]ser[Ss]ettings/

# MemoryCaptures can get excessive in size.
# They also could contain extremely sensitive data
/[Mm]emoryCaptures/

# Recordings can get excessive in size
/[Rr]ecordings/

# Uncomment this line if you wish to ignore the asset store tools plugin
# /[Aa]ssets/AssetStoreTools*

# Autogenerated Jetbrains Rider plugin
/[Aa]ssets/Plugins/Editor/JetBrains*

# Visual Studio cache directory
.vs/

# Gradle cache directory
.gradle/

# Autogenerated VS/MD/Consulo solution and project files
ExportedObj/
.consulo/
*.csproj
*.unityproj
*.sln
*.suo
*.tmp
*.user
*.userprefs
*.pidb
*.booproj
*.svd
*.pdb
*.mdb
*.opendb
*.VC.db

# Unity3D generated meta files
*.pidb.meta
*.pdb.meta
*.mdb.meta

# Unity3D generated file on crash reports
sysinfo.txt

# Builds
*.apk
*.aab
*.unitypackage
*.app

# Crashlytics generated file
crashlytics-build.properties

# Packed Addressables
/[Aa]ssets/[Aa]ddressable[Aa]ssets[Dd]ata/*/*.bin*

# Temporary auto-generated Android Assets
/[Aa]ssets/[Ss]treamingAssets/aa.meta
/[Aa]ssets/[Ss]treamingAssets/aa/*

# End of https://www.toptal.com/developers/gitignore/api/unity
EOF

# Create .gitattributes file
cat << EOF > .gitattributes
## Unity ##

*.cs diff=csharp text
*.cginc text
*.shader text

*.mat merge=unityyamlmerge eol=lf
*.anim merge=unityyamlmerge eol=lf
*.unity merge=unityyamlmerge eol=lf
*.prefab merge=unityyamlmerge eol=lf
*.physicsMaterial2D merge=unityyamlmerge eol=lf
*.physicMaterial merge=unityyamlmerge eol=lf
*.asset merge=unityyamlmerge eol=lf
*.meta merge=unityyamlmerge eol=lf
*.controller merge=unityyamlmerge eol=lf


## git-lfs ##

#Image
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.png filter=lfs diff=lfs merge=lfs -text
*.gif filter=lfs diff=lfs merge=lfs -text
*.psd filter=lfs diff=lfs merge=lfs -text
*.ai filter=lfs diff=lfs merge=lfs -text
*.tif filter=lfs diff=lfs merge=lfs -text

#Audio
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text

#Video
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text

#3D Object
*.FBX filter=lfs diff=lfs merge=lfs -text
*.fbx filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.obj filter=lfs diff=lfs merge=lfs -text

#ETC
*.a filter=lfs diff=lfs merge=lfs -text
*.exr filter=lfs diff=lfs merge=lfs -text
*.tga filter=lfs diff=lfs merge=lfs -text
*.pdf filter=lfs diff=lfs merge=lfs -text
*.zip filter=lfs diff=lfs merge=lfs -text
*.dll filter=lfs diff=lfs merge=lfs -text
*.unitypackage filter=lfs diff=lfs merge=lfs -text
*.aif filter=lfs diff=lfs merge=lfs -text
*.ttf filter=lfs diff=lfs merge=lfs -text
*.rns filter=lfs diff=lfs merge=lfs -text
*.reason filter=lfs diff=lfs merge=lfs -text
*.lxo filter=lfs diff=lfs merge=lfs -text
EOF

# Set up UnityYAMLMerge for Git
git config merge.tool unityyamlmerge
git config mergetool.unityyamlmerge.trustExitCode false
git config mergetool.unityyamlmerge.cmd "'$unity_yaml_merge_path' merge -p \"\$BASE\" \"\$REMOTE\" \"\$LOCAL\" \"\$MERGED\""

# Add all files to staging
git add .

# Make initial commit
git commit -m "Initial commit: Set up Unity project with .gitignore and .gitattributes"