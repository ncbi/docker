FROM centos:7 as amrbuild

ARG VERSION

USER root

RUN yum -y groupinstall 'Development Tools'
RUN yum -y install wget 

# build blast
WORKDIR /root/
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-src.tar.gz
RUN tar xvf ncbi-blast-2.7.1+-src.tar.gz
WORKDIR /root/ncbi-blast-2.7.1+-src/c++
RUN ./configure --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --prefix=/blast
WORKDIR /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/build
RUN make -j -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe

# build hmmer
WORKDIR /root/
RUN wget http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz
RUN tar xvf hmmer-3.1b2.tar.gz
WORKDIR /root/hmmer-3.1b2
RUN ./configure --enable-portable-binary --prefix=/hmmer && make && make install
WORKDIR easel
RUN make install

# build amr_report
WORKDIR /root/
COPY src src
WORKDIR src
RUN make clean && make

FROM centos:7

COPY VERSION .

USER root
WORKDIR /root

RUN yum -y install libgomp

# install blast
RUN mkdir -p /blast/bin /blast/lib
COPY --from=amrbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=amrbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/lib /blast/lib
WORKDIR /blast/blastdb
ENV BLASTDB /blast/blastdb
ENV PATH="/blast/bin:${PATH}"

# install hmmer
COPY --from=amrbuild /hmmer/bin /hmmer/bin
WORKDIR /hmmer/hmmerdb
ENV HMMERDB=/hmmer/hmmerdb
ENV PATH="/hmmer/bin:${PATH}"

# install amr_report
COPY --from=amrbuild /root/src/amr_report /root/src/fasta_check /root/src/gff_check /usr/bin/

CMD ["/bin/bash"]

