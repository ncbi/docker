FROM ubuntu:16.04
ARG version
COPY VERSION .

USER root
RUN apt-get -y -m update && apt-get install -y wget libidn11 libnet-perl liblist-moreutils-perl perl-doc

WORKDIR /usr
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-${version}+-x64-linux.tar.gz && tar xzf ncbi-blast-${version}+-x64-linux.tar.gz --strip-components=1 && rm ncbi-blast-${version}+-x64-linux.tar.gz

RUN mkdir -p /var/db/blast
ENV BLASTDB /var/db/blast
WORKDIR /tmp

CMD ["/bin/sh"]
