#!/bin/bash   

VERSION=local-$(date +%Y%m%d)
COMMIT_HASH=$(git rev-parse --short HEAD)

go build -ldflags "-X main.version=$VERSION -X main.commitHash=$COMMIT_HASH" -o hello-world