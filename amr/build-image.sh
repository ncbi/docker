#!/bin/bash

# Increment this to build from scratch including dependencies
VERSION=1.7

get_tarball_url() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" |
        fgrep '"browser_download_url":' |
        cut -d '"' -f 4
}

USERNAME=ncbi
IMAGE=amr
DB_VERSION=`curl --silent https://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/latest/version.txt`
SOFTWARE_VERSION=`curl --silent https://raw.githubusercontent.com/ncbi/amr/master/version.txt`
BINARY_URL=$(get_tarball_url ncbi/amr)
VERSION_TAG="${SOFTWARE_VERSION}-$DB_VERSION"

docker build --build-arg VERSION=${VERSION} --build-arg DB_VERSION=${DB_VERSION} \
    --build-arg SOFTWARE_VERSION=${SOFTWARE_VERSION} \
    --build-arg BINARY_URL=${BINARY_URL} \
    -t $USERNAME/$IMAGE:$VERSION_TAG . \
    && docker tag $USERNAME/$IMAGE:$VERSION_TAG $USERNAME/$IMAGE:latest

echo $VERSION_TAG > version_tag.txt

# temp for testing
# USERNAME=ncbi
# IMAGE=amr
# VERSION_TAG=3.10.23-2021-12-21.1

# Run some tests
docker run --rm $USERNAME/$IMAGE:$VERSION_TAG bash -c 'cd /usr/local/bin; ./test_amrfinder.sh'
if [ $? -gt 0 ]
then
    >&2 echo "ERROR! Tests for $USERNAME/$IMAGE:$VERSION_TAG failed"
    exit 1
else
    >&2 echo "To push to dockerhub run:"
    >&2 echo "docker push ncbi/amr:$VERSION_TAG"
fi
