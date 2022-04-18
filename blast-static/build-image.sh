#!/bin/bash

USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=`curl https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION`

case $(uname -m) in
	x86_64) ARCH=amd64;;
	aarch64) ARCH=arm64;;
esac


docker build --build-arg version=${VERSION} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:${VERSION}-${ARCH}
