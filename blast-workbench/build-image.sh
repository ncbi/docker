#!/bin/bash -ex

USERNAME=ncbi
IMAGE=blast-workbench
VERSION=0.1

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
