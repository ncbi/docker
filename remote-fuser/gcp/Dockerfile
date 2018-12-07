FROM ubuntu:18.04
LABEL Description="remote-fuser configured to retrieve BLAST databases from GCP" \
    Vendor="NCBI/NLM/NIH" \
    URL="https://github.com/ncbi/sra-tools" \
    Maintainer=camacho@ncbi.nlm.nih.gov 

USER root
WORKDIR /tmp

RUN apt-get -y -m update && \
    apt-get install -y fuse libxml2-dev curl && \
    rm -rf /var/lib/apt/lists/*

COPY remote-fuser /sbin/
COPY remote-fuser.sh /sbin/
RUN chmod +x /sbin/remote-fuser /sbin/remote-fuser.sh

RUN mkdir -p /blast/blastdb

WORKDIR /blast
CMD [ "/sbin/remote-fuser.sh" ]
