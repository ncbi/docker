FROM ubuntu:latest

MAINTAINER aprasad@ncbi.nlm.nih.gov

ARG VERSION

USER root

# basic setup
RUN apt-get update && apt-get install -y hmmer ncbi-blast+ libcurl4-openssl-dev curl

ARG SOFTWARE_VERSION

ARG BINARY_URL

# Install AMRFinderPlus
RUN cd /usr/local/bin && curl --silent -L ${BINARY_URL} | tar xvfz -

ARG DB_VERSION

RUN amrfinder -u

WORKDIR /data

# Example commands: 
# docker run --rm -v ${PWD}:/data ncbi/amr \
#     amrfinder -p test_prot.fa --threads 8

# docker run --rm -v ${PWD}:/data ncbi/amr \
#    'amrfinder -u && amrfinder -p test_prot.fa --threads 8'
