#!/bin/bash

USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=`cat VERSION`

ARCH=
if [ $(uname -m) != x86_64 ] ; then
    ARCH="-$(uname -m)"
fi

docker build --build-arg version=${VERSION} -t $USERNAME/$IMAGE:${VERSION}${ARCH} .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
