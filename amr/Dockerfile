FROM ubuntu

LABEL maintainer="Arjun Prasad <aprasad@ncbi.nlm.nih.gov>"

ARG VERSION

USER root

# basic setup
RUN apt-get update && apt-get install -y hmmer ncbi-blast+ libcurl4-openssl-dev curl

ARG SOFTWARE_VERSION

ARG BINARY_URL

# Install AMRFinderPlus
WORKDIR /usr/local/bin
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --silent -L ${BINARY_URL} | tar xvfz -

ARG DB_VERSION

RUN amrfinder -u

# Test installation
WORKDIR /usr/local/bin
RUN ./test_amrfinder.sh

WORKDIR /data

#  Example commands
# ------------------
# Run on a local file with 8 threads
# docker run --rm -v ${PWD}:/data ncbi/amr \
#     amrfinder -p test_prot.fa --threads 8
#
# Update the database then run on a local file (new images are released with
# every database release, so you shouldn't need to do this if your image is up
# to date)
# docker run --rm -v ${PWD}:/data ncbi/amr \
#    bash -c 'amrfinder -u && amrfinder -p test_prot.fa --threads 8' \
#    > amrfinder.out
