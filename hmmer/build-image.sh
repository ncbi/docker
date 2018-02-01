#!/bin/bash

USERNAME=ncbi
IMAGE=hmmer
VERSION=`cat VERSION`

#wget -nc http://eddylab.org/software/hmmer3/${VERSION}/hmmer-${VERSION}.tar.gz

docker build --build-arg VERSION=${VERSION} -t $USERNAME/$IMAGE:$VERSION . \
    && docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
