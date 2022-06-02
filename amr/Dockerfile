FROM ubuntu:latest

MAINTAINER aprasad@ncbi.nlm.nih.gov

ARG VERSION

USER root

# basic setup
RUN apt-get update && apt-get install -y hmmer ncbi-blast+ libcurl4-openssl-dev curl

ARG SOFTWARE_VERSION

ARG BINARY_URL

# Install AMRFinderPlus
RUN cd /usr/local/bin && curl --silent -L ${BINARY_URL} | tar xvfz - \
    && curl -O https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_both.expected \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_dna.expected \
         -O https://raw.githubusercontent.com/ncbi/amr/master/test_prot.expected

ARG DB_VERSION

RUN amrfinder -u

# Test installation
RUN cd /usr/local/bin \
        && amrfinder --plus -n test_dna.fa -p test_prot.fa -g test_prot.gff -O Escherichia > test_both.got \
        && diff test_both.expected test_both.got

WORKDIR /data

# Example commands: 
# docker run --rm -v ${PWD}:/data ncbi/amr \
#     amrfinder -p test_prot.fa --threads 8

# docker run --rm -v ${PWD}:/data ncbi/amr \
#    'amrfinder -u && amrfinder -p test_prot.fa --threads 8'
