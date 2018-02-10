#!/bin/bash
#set -ex

wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/slottad/amr/AMRProt

USERNAME=ncbi
IMAGE=blast_amr
VERSION=`cat VERSION`

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest
