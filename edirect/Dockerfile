FROM ubuntu:22.04
ARG version
LABEL Description="NCBI EDirect" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root

RUN apt-get -y -m update && apt-get install -y curl cpanminus libxml-simple-perl libwww-perl libnet-perl build-essential && rm -rf /var/lib/apt/lists/*

RUN sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
#RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz | \
# tar xzf - && \
# cpanm HTML::Entities && \
# ls -l && \
# edirect/setup.sh

COPY installconfirm /root
#COPY installconfirm ${HOME}/edirect/

ENV PATH="/root/edirect:${PATH}"

#WORKDIR /root

CMD ["/bin/bash"]

