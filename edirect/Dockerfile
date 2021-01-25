FROM ubuntu:18.04
ARG version
LABEL Description="NCBI EDirect" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /usr/local/ncbi

RUN apt-get -y -m update && apt-get install -y curl cpanminus libxml-simple-perl libwww-perl libnet-perl build-essential && rm -rf /var/lib/apt/lists/*

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz | \
 tar xzf - && \
 cpanm HTML::Entities && \
 edirect/setup.sh

COPY installconfirm /usr/local/ncbi/edirect/

ENV PATH="/usr/local/ncbi/edirect:${PATH}"

WORKDIR /root

CMD ["/bin/bash"]

