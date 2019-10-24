#!/bin/bash -eu

DOCKER_USERNAME=${1:-"ncbi"}
IMAGE=blast
VERSION=`cat VERSION`
NP=`grep -c ^proc /proc/cpuinfo`

docker build --build-arg version=${VERSION} --build-arg num_procs=${NP} -t $DOCKER_USERNAME/$IMAGE:$VERSION .
docker tag $DOCKER_USERNAME/$IMAGE:$VERSION $DOCKER_USERNAME/$IMAGE:latest
