FROM ubuntu:latest

MAINTAINER aprasad@ncbi.nlm.nih.gov

ARG VERSION

USER root

# basic setup
RUN apt-get update && apt-get install -y hmmer ncbi-blast+ git libcurl4-openssl-dev build-essential

# Install AMRFinderPlus
RUN git clone https://github.com/ncbi/amr.git \
        && cd amr \
        && make \
        && make install \
        && cd .. \
        && rm -rf amr 

ARG DB_VERSION
RUN amrfinder -u

WORKDIR /data

# Example commands: 
# docker run --rm -v ${PWD}:/data ncbi/amr \
#     amrfinder -p test_prot.fa --threads 8

# docker run --rm -v ${PWD}:/data ncbi/amr \
#    'amrfinder -u && amrfinder -p test_prot.fa --threads 8'
