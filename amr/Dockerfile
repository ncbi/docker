FROM ubuntu:22.04 AS builder

LABEL maintainer="Arjun Prasad <aprasad@ncbi.nlm.nih.gov>"

ARG VERSION

USER root

# basic setup
# RUN apt-get update && apt-get install -y hmmer ncbi-blast+ libcurl4-openssl-dev curl
# Set up to compile
RUN apt-get update && apt-get install -y hmmer git libcurl4-openssl-dev build-essential

ARG SOFTWARE_VERSION

ARG BINARY_URL

# Install AMRFinderPlus
# WORKDIR /usr/local/bin
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# RUN curl --silent -L ${BINARY_URL} | tar xvfz -
# Compile AMRFinderPlus -- Requires Set up to compile above
RUN git clone https://github.com/ncbi/amr.git \
        && cd amr \
        && git submodule update --init \
        && make -j -O \
        && make install INSTALL_DIR=/amrfinder


# Now make image for software 
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y hmmer libcurl4-openssl-dev curl libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install blast binary (swtiched becuase of extremely slow blastx from apt)
# Define BLAST version for reproducibility
ENV BLAST_VERSION=2.17.0

# Download, extract, and cleanup in a single layer to save space
RUN curl -L -O https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz \
    && tar -zxvf ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz \
    && cp -r ncbi-blast-${BLAST_VERSION}+/bin/* /usr/local/bin/ \
    && rm ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz \
    && rm -rf ncbi-blast-${BLAST_VERSION}+

# Verification step
RUN blastn -version

COPY --from=builder /amrfinder/ /usr/local/bin

ARG DB_VERSION

RUN amrfinder -u

WORKDIR /amrfinder

# now test
RUN BASE_URL=https://raw.githubusercontent.com/ncbi/amr/master \
    && curl --silent -L -O ${BASE_URL}/test_amrfinder.sh \
        && pwd \
        && ls -al \
        && chmod a+x test_amrfinder.sh \
        && ./test_amrfinder.sh -p

# Test installation
# WORKDIR /amrfinder
#RUN ./test_amrfinder.sh -p

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
