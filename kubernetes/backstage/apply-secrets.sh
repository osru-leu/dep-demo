#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if GITHUB_TOKEN is set
if [ -z "${GITHUB_TOKEN}" ]; then
    echo "Error: GITHUB_TOKEN environment variable is not set"
    echo "Please set it first:"
    echo "export GITHUB_TOKEN=your_token"
    exit 1
fi

# Create the backstage namespace if it doesn't exist
echo "Creating backstage namespace if it doesn't exist..."
kubectl create namespace backstage --dry-run=client -o yaml | kubectl apply -f -

# Use envsubst to replace environment variables in the secrets file
echo "Applying secrets..."
envsubst < "${SCRIPT_DIR}/secrets.yaml" | kubectl apply -f -

echo "Secrets applied successfully!" 