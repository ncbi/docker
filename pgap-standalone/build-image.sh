#!/bin/bash
set -ex

USERNAME=ncbi
IMAGE=pgap-standalone
VERSION=`cat VERSION`

docker build --build-arg PGAP_VERSION="${VERSION}" -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
