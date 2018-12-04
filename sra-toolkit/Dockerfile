FROM ubuntu:18.04
LABEL Description="NCBI SRA toolkit" \
    Vendor="NCBI/NLM/NIH" \
    URL="https://github.com/ncbi/sra-tools" \
    Maintainer=camacho@ncbi.nlm.nih.gov 
ARG version

USER root
WORKDIR /tmp

RUN apt-get -y -m update && \
    apt-get install -y \
    fuse libxml2-dev \
    curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/ncbi/sra-toolkit
WORKDIR /usr/local/ncbi/sra-toolkit
RUN curl -s https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${version}/sratoolkit.${version}-ubuntu64.tar.gz | \
    tar zxf - --strip-components=1

ENV PATH="/usr/local/ncbi/sra-toolkit/bin:${PATH}"
WORKDIR /tmp
CMD ["/bin/bash"]
