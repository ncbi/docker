#!/bin/bash

USERNAME=ncbi
IMAGE=amr
VERSION=1.6
DB_VERSION=`curl --silent https://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/latest/version.txt`
SOFTWARE_VERSION=`curl --silent https://raw.githubusercontent.com/ncbi/amr/master/version.txt`
VERSION_TAG="${SOFTWARE_VERSION}-$DB_VERSION"

docker build --build-arg VERSION=${VERSION} --build-arg DB_VERSION=${DB_VERSION} \
    --build-arg SOFTWARE_VERSION=${SOFTWARE_VERSION} \
    -t $USERNAME/$IMAGE:$VERSION_TAG . \
    && docker tag $USERNAME/$IMAGE:$VERSION_TAG $USERNAME/$IMAGE:latest

