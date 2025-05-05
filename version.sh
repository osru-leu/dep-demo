#!/bin/bash   

# VERSION=local-$(date +%Y%m%d)
# COMMIT_HASH=$(git rev-parse --short HEAD)
BRANCH=${GITHUB_REF##*/}
CLEAN_BRANCH=$(echo "${BRANCH}" | tr -d '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
VERSION=${CLEAN_BRANCH}-$(date +%Y%m%d).${GITHUB_RUN_NUMBER}
COMMIT_HASH=$(git rev-parse HEAD)

go build -ldflags "-X main.version=$VERSION -X main.commitHash=$COMMIT_HASH" -o hello-world