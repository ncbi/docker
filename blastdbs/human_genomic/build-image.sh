#!/bin/bash
#set -ex

mkdir -p tarballs
mkdir -p databases
cd tarballs
files=`curl -s -l ftp://ftp.ncbi.nlm.nih.gov/blast/db/ | grep ^human_genomic\..*\.tar\.gz$`
for i in ${files}; do
    wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/db/${i}
done
cd ..

USERNAME=ncbi
IMAGE=human_genomic
VERSION=`cat VERSION`

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest

# && tar xvf human_genomic.${i}.tar.gz -C ../databases --keep-newer-files
