#!/bin/bash -eux

DOCKERHUB_USERNAME=${1:-"ncbi"}
IMAGE=blast
VERSION=`curl -s https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION`
# Check the latest ncbi-vdb release version in https://github.com/ncbi/ncbi-vdb/tags
VDB_VERSION=3.0.0
NP=`grep -c ^proc /proc/cpuinfo`

docker build --build-arg version=${VERSION} --build-arg num_procs=${NP} --build-arg vdb_version=${VDB_VERSION} -t $DOCKERHUB_USERNAME/$IMAGE:$VERSION .
docker tag $DOCKERHUB_USERNAME/$IMAGE:$VERSION $DOCKERHUB_USERNAME/$IMAGE:latest
