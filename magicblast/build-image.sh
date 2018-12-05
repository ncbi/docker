#!/bin/bash -xe

USERNAME=ncbi
IMAGE=magicblast
VERSION=`cat VERSION`
NP=`grep -c proc /proc/cpuinfo`

docker build --build-arg num_procs=${NP} --build-arg version=${VERSION} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
