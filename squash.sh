#!/bin/bash

squash_commits() {
    prefix=$1
    # Get list of commits with prefix, newest first
    commits=$(git log --oneline | grep "^.*$prefix" | awk '{print $1}')

    if [ -z "$commits" ]; then
        echo "No commits found with prefix: $prefix"
        return
    fi

    # Create a temporary rebase todo file
    temp_file=$(mktemp)
    oldest_commit=$(echo "$commits" | tail -n1)
    echo "Processing commits with prefix '$prefix' from $oldest_commit"
    
    # Write the rebase commands to the temp file
    echo "pick ${oldest_commit} $(git log --format=%B -n 1 ${oldest_commit})" > "$temp_file"
    
    # Add squash commands for other commits
    while read -r commit; do
        if [ "$commit" != "$oldest_commit" ]; then
            echo "squash ${commit} $(git log --format=%B -n 1 ${commit})" >> "$temp_file"
        fi
    done <<< "$commits"

    # Use the temp file for rebasing
    export GIT_SEQUENCE_EDITOR="cat $temp_file >"
    git rebase -i "${oldest_commit}^"
    
    # Cleanup
    rm "$temp_file"
}

# List of conventional commit prefixes
prefixes=("fix:" "feat:" "build:" "docs:" "style:" "refactor:" "perf:" "test:" "chore:")

# Iterate over each prefix and squash commits
for prefix in "${prefixes[@]}"; do
    squash_commits "$prefix"
done