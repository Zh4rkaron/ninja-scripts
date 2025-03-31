#!/bin/bash

repo_url=""
branch="main"  # Default branch
usage() {
    echo "Usage: gitpull <repository-url> [-b <branch>]"
    exit 1
}

# Argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -b)
            branch="$2"
            shift 2
            ;;
        *)
            repo_url="$1"
            shift
            ;;
    esac
done

# Check required argument
if [[ -z "$repo_url" ]]; then
    usage
fi

# Extract the repository name from the URL
repo_name=$(basename "$repo_url" .git)

# Check if the repository folder exists
if [ -d "$repo_name" ]; then
    cd "$repo_name" || exit
    echo "Pulling the latest changes from $repo_url (branch: $branch)..."
    git pull origin "$branch"
else
    echo "Repository not found locally. Cloning the repository..."
    git clone "$repo_url"
    cd "$repo_name" || exit
    git checkout "$branch"
fi
