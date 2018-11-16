#!/bin/bash -e

USERNAME=ncbi
IMAGE=edirect
VERSION=`cat VERSION`

docker build --build-arg version=${VERSION} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
