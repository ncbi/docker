#!/bin/bash

DOCKERHUB_USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=${2:-$(curl -sSL https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION)}

docker manifest create "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" \
	--amend "$DOCKERHUB_USERNAME"/$IMAGE:"${VERSION}"-amd64 \
	--amend "$DOCKERHUB_USERNAME"/$IMAGE:"${VERSION}"-arm64

# The command below pushes multi-architecture image to docker hub
#docker manifest push $DOCKERHUB_USERNAME/$IMAGE:$VERSION
