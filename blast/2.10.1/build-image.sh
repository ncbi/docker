#!/bin/bash -eux

DOCKERHUB_USERNAME=${1:-"ncbi"}
#DOCKERHUB_USERNAME=${1:-"christiam"}
IMAGE=blast
#IMAGE=blast-debug
VERSION=`cat VERSION`
NP=`grep -c ^proc /proc/cpuinfo`
GCP_PROJECT=ncbi-sandbox-blast

docker build --build-arg version=${VERSION} --build-arg num_procs=${NP} -t $DOCKERHUB_USERNAME/$IMAGE:$VERSION .
#docker tag $DOCKERHUB_USERNAME/$IMAGE:$VERSION $DOCKERHUB_USERNAME/$IMAGE:latest
echo "FIXME"
docker tag $DOCKERHUB_USERNAME/$IMAGE:$VERSION gcr.io/$GCP_PROJECT/$DOCKERHUB_USERNAME/$IMAGE:$VERSION
docker push gcr.io/$GCP_PROJECT/$DOCKERHUB_USERNAME/$IMAGE:$VERSION
#docker tag $DOCKERHUB_USERNAME/$IMAGE:$VERSION gcr.io/$GCP_PROJECT/$DOCKERHUB_USERNAME/$IMAGE:latest
