#!/bin/bash

USERNAME=ncbi
IMAGE=amr
VERSION=1.5
DB_VERSION=`curl https://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/latest/version.txt`

docker build --build-arg VERSION=${VERSION} --build-arg DB_VERSION=${DB_VERSION} -t $USERNAME/$IMAGE:$DB_VERSION . \
    && docker tag $USERNAME/$IMAGE:$DB_VERSION $USERNAME/$IMAGE:latest

