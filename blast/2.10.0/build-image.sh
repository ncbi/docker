#!/bin/bash -e

USERNAME=christiam
IMAGE=blast
VERSION=`cat VERSION`
NP=`grep -c ^proc /proc/cpuinfo`

docker build --build-arg version=${VERSION} --build-arg num_procs=${NP} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
