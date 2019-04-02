#!/bin/bash -ex

USERNAME=ncbi
IMAGE=blast-workbench
VERSION=0.2

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
