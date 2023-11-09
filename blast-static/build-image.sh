#!/bin/bash 
set -xeuo pipefail

DOCKERHUB_USERNAME=${1:-"ncbi"}
IMAGE=blast-static
VERSION=$(curl -sSL https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION)

case $(uname -m) in
	x86_64) ARCH=amd64;;
	aarch64) ARCH=arm64;;
esac


docker build --progress=plain --build-arg version="${VERSION}" -t "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" --pull --no-cache . 2>&1 | tee build.log
docker tag "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" "$DOCKERHUB_USERNAME"/$IMAGE:latest
docker tag "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" "$DOCKERHUB_USERNAME"/$IMAGE:"${VERSION}"-${ARCH}
