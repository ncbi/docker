#!/bin/bash
set -xeuo pipefail

DOCKERHUB_USERNAME=${1:-"ncbi"}
IMAGE=blast
VERSION=$(cat VERSION)
# Check the latest ncbi-vdb release version in https://github.com/ncbi/ncbi-vdb/tags
# To see which VDB version is currently used by C++ Toolkit do:
#  grep local_vdb_base src/build-system/config.site.ncbi
VDB_VERSION=3.0.8
NP=$(grep -c ^proc /proc/cpuinfo)

docker build --progress=plain --build-arg blast_version="${VERSION}" --build-arg num_procs="${NP}" --build-arg vdb_version=${VDB_VERSION} -t "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" --pull --no-cache . 2>&1 | tee build.log
docker tag "$DOCKERHUB_USERNAME"/$IMAGE:"$VERSION" "$DOCKERHUB_USERNAME"/$IMAGE:latest
