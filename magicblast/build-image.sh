#!/bin/bash -xe

USERNAME=ncbi
IMAGE=magicblast
VERSION=`cat VERSION`
# Check the latest ncbi-vdb release version in https://github.com/ncbi/ncbi-vdb/tags
# To see which VDB version is currently used by C++ Toolkit do:
#  grep local_vdb_base src/build-system/config.site.ncbi
VDB_VERSION=3.0.7
NP=`grep -c proc /proc/cpuinfo`

docker build --build-arg num_procs=${NP} --build-arg version=${VERSION} --build-arg vdb_version=${VDB_VERSION} -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
