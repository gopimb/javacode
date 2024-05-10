#!/bin/bash

# Prompt for the repository URL
read -p "Enter the URL of the repository: " repository_url

# Check if repository URL is provided
if [ -z "$repository_url" ]; then
    echo "Repository URL is required."
    exit 1
fi

# Clone the repository
git clone "$repository_url"

# Extract repository name from URL
repository_name=$(basename "$repository_url" .git)

# Navigate into the cloned repository
cd "$repository_name"
ls -lart

# Prompt for the folder name
read -p "Enter the name of the folder: " folder_name

# Check if folder name is provided
if [ -z "$folder_name" ]; then
    echo "Folder name is required."
    exit 1
fi
cd $folder_name
# Get the list of files from the last commit
file_list=$(git diff-tree --no-commit-id --name-only -r HEAD)

# Extract just the file names without the path
file_names=$(echo "$file_list" | xargs -n1 basename)

# Print the list of file names
echo "Files changed in the last commit:"
echo "$file_names"

echo "Tags associated with the latest file changes as compared to CSV file:"

# Loop through each file and find associated tags
for file in $file_names
do
    tags=$(awk -F',' -v file="$file" '$1 == file {print $2}' TestCaseTags.csv)
    echo "$file: $tags"
done