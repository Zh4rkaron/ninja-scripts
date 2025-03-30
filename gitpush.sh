#!/bin/bash

# Default values
name="$PWD"  # Default to current directory
repo=""
description="Commit to repository"  # Default commit message if none is provided

# Display usage instructions
usage() {
    echo "Usage: $0 <directory> -o <repository-url>"
    exit 1
}

# Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o)
            repo="$2"  # Set the remote repository URL (SSH or HTTPS)
            shift 2
            ;;
        *)
            name="$1"  # Set the directory (first argument, if provided)
            shift
            ;;
    esac
done

# Check if the repository URL is provided
if [[ -z "$repo" ]]; then
    usage
fi

# If no directory is specified, use the current directory
if [[ -z "$name" ]]; then
    name="$PWD"
fi

# Check if the specified directory exists
if [ ! -d "$name" ]; then
    echo "Error: Directory '$name' does not exist."
    exit 1
fi

# Change to the specified directory
cd "$name" || exit

# Check if the directory is already a Git repository
if [ ! -d ".git" ]; then
    # Initialize Git repository if it's not already initialized
    echo "Initializing Git repository in $name..."
    git init
else
    echo "Git repository already initialized in $name."
fi

# Check if the remote repository is already set
existing_remote=$(git remote get-url origin 2>/dev/null)

if [[ -z "$existing_remote" ]]; then
    # Add the remote repository URL if it's not already set
    echo "Setting remote repository to $repo..."
    git remote add origin "$repo"
else
    echo "Remote repository already set to $existing_remote."
fi

# Stage changes, commit, and push to the repository
echo "Staging changes and committing..."
git add .
git commit -m "$description"
git branch -M main

# Push the changes to the specified remote repository
echo "Pushing changes to remote repository..."
git push -u origin main
