#!/bin/bash   

VERSION=local-$(date +%Y%m%d)
COMMIT_HASH=$(git rev-parse --short HEAD)
RUN_NUMBER=${1:-local}

go build -ldflags "-X main.version=$VERSION.$RUN_NUMBER -X main.commitHash=$COMMIT_HASH" -o hello-world