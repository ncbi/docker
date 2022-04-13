#!/bin/bash

USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=`cat VERSION`

case $(uname -m) in
	x86_64) ARCH=x64;;
	aarch64) ARCH=x64-arm;;
esac

docker build --build-arg version=${VERSION} --build-arg arch=${ARCH} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
