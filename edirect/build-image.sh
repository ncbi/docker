#!/bin/bash -eux

DOCKERHUB_USERNAME=${1:-"ncbi"}
IMAGE=edirect
VERSION=`cat VERSION`

docker build --build-arg version=${VERSION} -t $DOCKERHUB_USERNAME/$IMAGE:$VERSION .
docker tag $DOCKERHUB_USERNAME/$IMAGE:$VERSION $DOCKERHUB_USERNAME/$IMAGE:latest
