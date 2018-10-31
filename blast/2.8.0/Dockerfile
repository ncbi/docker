FROM ubuntu:18.04 as blastbuild

ARG version
LABEL Description="NCBI BLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl libidn11 libnet-perl liblist-moreutils-perl perl-doc

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}alpha/ncbi-blast-${version}-alpha+-src.tar.gz | \
 tar xzf - && \
 cd ncbi-blast-${version}+-src/c++ && \
 ./configure --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --prefix=/blast && \
 cd ReleaseMT/build && \
 make -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe


FROM ubuntu:18.04
ARG version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libgomp1 libnet-perl liblist-moreutils-perl perl-doc && && -rf /var/lib/apt/lists/*

RUN mkdir -p /blast/bin /blast/lib
COPY --from=blastbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=blastbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/lib /blast/lib

RUN mkdir -p /blast/blastdb /blast/blastdb_custom
RUN sed -i '$ a BLASTDB=/blast/blastdb:/blast/blastdb_custom' /etc/environment
ENV BLASTDB /blast/blastdb:/blast/blastdb_custom
ENV PATH="/blast/bin:${PATH}"

WORKDIR /blast

CMD ["/bin/bash"]

