FROM ubuntu:16.04 as blastbuild

ARG version

USER root
WORKDIR /root/

COPY ncbi-blast-2.7.1+-src.tar.gz /root
RUN tar xvf ncbi-blast-2.7.1+-src.tar.gz

RUN apt-get -y -m update && apt-get install -y build-essential wget libidn11

WORKDIR /root/ncbi-blast-2.7.1+-src/c++
RUN ./configure --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --prefix=/blast
WORKDIR /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/build
RUN make -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe


FROM ubuntu:16.04

COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libgomp1

RUN mkdir -p /blast/bin /blast/lib
COPY --from=blastbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=blastbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/lib /blast/lib

WORKDIR /blast/blastdb
ENV BLASTDB /blast/blastdb
ENV PATH="/blast/bin:${PATH}"

CMD ["/bin/bash"]

