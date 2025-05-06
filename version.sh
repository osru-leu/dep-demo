#!/bin/bash   

# Determine CI or Local
if [ -n "$GITHUB_REF" ]; then
    # Github env
    BRANCH=${GITHUB_REF}
    RUN_NUMBER=${GITHUB_RUN_NUMBER}
elif [ -n "$BITBUCKET_BRANCH" ]; then
    # Bitbucket env
    BRANCH=${BITBUCKET_BRANCH}
    RUN_NUMBER=${BITBUCKET_BUILD_NUMBER}
else
    # Local env
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    RUN_NUMBER="local"
fi

# Remove prefix e.g., feature/
BRANCH=${BRANCH#*/}

CLEAN_BRANCH=$(echo "${BRANCH}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')
VERSION=${CLEAN_BRANCH}-$(date +%Y%m%d).${RUN_NUMBER}
COMMIT_HASH=$(git rev-parse HEAD)

echo "Building with VERSION=$VERSION and COMMIT_HASH=$COMMIT_HASH"
go build -ldflags "-X main.version=$VERSION -X main.commitHash=$COMMIT_HASH" -o hello-world