#!/bin/bash -ex

USERNAME=christiam
IMAGE=blast-workbench
VERSION=0.1

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
