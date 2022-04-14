FROM ubuntu:18.04
ARG version
COPY VERSION .

USER root
RUN apt-get -y -m update && apt-get install -y wget libidn11 libnet-perl liblist-moreutils-perl perl-doc libgomp1 libxml2

WORKDIR /usr
RUN if [ $(uname -m) = x86_64 ] ; then arch=x64; \
    elif [ $(uname -m) = aarch64 ] ; then arch=x64-arm; \
    else echo "Architecture $(uname -m) is not supported" >&2; exit 1; \
    fi &&  wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-${version}+-${arch}-linux.tar.gz && tar xzf ncbi-blast-${version}+-${arch}-linux.tar.gz --strip-components=2 && rm ncbi-blast-${version}+-${arch}-linux.tar.gz

RUN mkdir -p /var/db/blast
ENV BLASTDB /var/db/blast
WORKDIR /tmp

CMD ["/bin/sh"]
