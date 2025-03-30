#!/bin/bash

name=""
visibility="public"  # Default visibility
description="New repository"

usage() {
    echo "Usage: gitnew <name> [-s public|private] -d <description>"
    exit 1
}

# Argument parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -s)
            visibility="$2"
            if [[ "$visibility" != "public" && "$visibility" != "private" ]]; then
                echo "Error: Visibility must be 'public' or 'private'."
                usage
            fi
            shift 2
            ;;
        -d)
            description="$2"
            shift 2
            ;;
        *)
            name="$1"
            shift
            ;;
    esac
done

# Check required arguments
if [[ -z "$name" || -z "$description" ]]; then
    usage
fi

# Check if the user is logged into GitHub CLI
if [ -s "$HOME/.config/gh/hosts.yml" ]; then
    echo -e "You're logged into your GitHub account.\nCreating repository $name..."
else
    echo -e "You're not logged into your GitHub account.\nLogging you in..."
    gh auth login || { echo "GitHub login failed. Exiting."; exit 1; }
fi

# Create the repository
gh repo create "$name" --"$visibility" --description "$description"
