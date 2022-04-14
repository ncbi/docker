#!/bin/bash

USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=`cat VERSION`

docker manifest create $USERNAME/$IMAGE:$VERSION \
	--amend $USERNAME/$IMAGE:${VERSION}-amd64 \
	--amend $USERNAME/$IMAGE:${VERSION}-arm64

# The command below pushes multi-architecture image to docker hub
#docker manifest push $USERNAME/$IMAGE:$VERSION
