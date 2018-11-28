FROM ubuntu:18.04 as blastbuild

ARG version
ARG num_procs=8
LABEL Description="NCBI BLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl libidn11 libnet-perl liblist-moreutils-perl perl-doc liblmdb-dev

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${version}alpha/ncbi-blast-${version}-alpha+-src.tar.gz | \
 tar xzf - && \
 cd ncbi-blast-${version}+-src/c++ && \
 ./configure --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j ${num_procs} -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe


FROM ubuntu:18.04
ARG version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libgomp1 libnet-perl libxml-simple-perl liblist-moreutils-perl libjson-perl perl-doc liblmdb-dev parallel vmtouch cpanminus wget curl && rm -rf /var/lib/apt/lists/*  && cpanm HTML::Entities

RUN mkdir -p /blast/bin /blast/lib
COPY --from=blastbuild /root/ncbi-blast-${version}+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=blastbuild /root/ncbi-blast-${version}+-src/c++/ReleaseMT/lib /blast/lib


RUN mkdir -p /blast/blastdb /blast/blastdb_custom
RUN sed -i '$ a BLASTDB=/blast/blastdb:/blast/blastdb_custom' /etc/environment
ENV BLASTDB /blast/blastdb:/blast/blastdb_custom
ENV PATH="/root/edirect:/blast/bin:${PATH}"

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/temp/update_blastdb.pl -o update_blastdb.pl && install -m 755 update_blastdb.pl /blast/bin/ && rm -f update_blastdb.pl

RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/blastdb_path -O /blast/bin/blastdb_path && chmod +x /blast/bin/blastdb_path
RUN cp  /blast/bin/blastp /blast/bin/blastp.REAL
RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/blastp.sh -O /blast/bin/blastp  && chmod +x /blast/bin/blastp
RUN cp  /blast/bin/blastn /blast/bin/blastn.REAL
RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/blastn.sh -O /blast/bin/blastn  && chmod +x /blast/bin/blastn
RUN cp  /blast/bin/blastx /blast/bin/blastx.REAL
RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/blastx.sh -O /blast/bin/blastx  && chmod +x /blast/bin/blastx
RUN cp  /blast/bin/tblastn /blast/bin/tblastn.REAL
RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/tblastn.sh -O /blast/bin/tblastn  && chmod +x /blast/bin/tblastn
RUN cp  /blast/bin/tblastx /blast/bin/tblastx.REAL
RUN wget -q ftp://ftp.ncbi.nlm.nih.gov/blast/temp/tblastx.sh -O /blast/bin/tblastx  && chmod +x /blast/bin/tblastx
RUN echo 'will cite' | parallel --citation

#FROM christiam/edirect as edirect
RUN mkdir -p /root
COPY --from=christiam/edirect /usr/local/ncbi/edirect /root/edirect
#COPY --from=edirect /usr/local/ncbi/edirect /root/edirect

WORKDIR /blast

CMD ["/bin/bash"]

