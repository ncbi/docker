FROM ubuntu:18.04
ARG source=NCBI
LABEL Description="remote-fuser configured to retrieve BLAST databases from ${source}" \
    Vendor="NCBI/NLM/NIH" \
    URL="https://github.com/ncbi/sra-tools" \
    Maintainer=camacho@ncbi.nlm.nih.gov 

USER root
WORKDIR /tmp

RUN apt-get -y -m update && \
    apt-get install -y \
    fuse libxml2-dev \
    curl \
    libconfig-simple-perl \
    libreadonly-perl \
    perl-doc && \
    rm -rf /var/lib/apt/lists/*

COPY remote-fuser /sbin
COPY remote-fuser-ctl.pl /sbin/
RUN chmod +x /sbin/remote-fuser-ctl.pl /sbin/remote-fuser
WORKDIR /etc
COPY remote-fuser-ctl.ini .

RUN mkdir -p /blast/blastdb

WORKDIR /blast
CMD ["/sbin/remote-fuser-ctl.pl", "--start", "--verbose", "--foreground", "--config", "/etc/remote-fuser-ctl.ini" ]
