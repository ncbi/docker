#!/bin/bash

USERNAME=ncbi
IMAGE=blast
VERSION=`cat VERSION`

#wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-${VERSION}+-src.tar.gz

docker build --build-arg version=${VERSION} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
