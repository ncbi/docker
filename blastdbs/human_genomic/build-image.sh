#!/bin/bash
set -ex

mkdir -p tarballs
mkdir -p databases
cd tarballs
for i in {00..22}; do
    wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/db/human_genomic.${i}.tar.gz \
        && tar xvf human_genomic.${i}.tar.gz -C ../databases --keep-newer-files
done
cd ..

USERNAME=slottad
IMAGE=human_genomic
VERSION=`cat VERSION`

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest

