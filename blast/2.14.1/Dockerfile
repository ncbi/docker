FROM ncbi/edirect:12.5 as edirect
FROM ubuntu:18.04 as blastbuild
ARG blast_version
ARG vdb_version
ARG num_procs=8
LABEL Description="NCBI BLAST" Vendor="NCBI/NLM/NIH" Version=${blast_version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl libidn11 libnet-perl perl-doc liblmdb-dev wget

# cmake installed by apt is currently too old
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3-linux-x86_64.tar.gz && tar xfz cmake-3.22.3-linux-x86_64.tar.gz && rm cmake-3.22.3-linux-x86_64.tar.gz
ENV PATH="${PATH}:/root/cmake-3.22.3-linux-x86_64/bin"

# Download and build ncbi-vdb
RUN wget https://github.com/ncbi/ncbi-vdb/archive/refs/tags/${vdb_version}.tar.gz && \
    tar xfz ${vdb_version}.tar.gz && rm ${vdb_version}.tar.gz && \
    mv ncbi-vdb-${vdb_version} ncbi-vdb && \
    cd ncbi-vdb && ./configure --prefix /root/vdb && make install -j ${num_proc}

# Arrange ncbi-vdb libraries and header files in a form that C++ toolkit
# build can consume them.
ARG VDB=/root/VDB
RUN mkdir -p ${VDB}/linux/release/x86_64/lib && \
    cp -R /root/vdb/lib64/* ${VDB}/linux/release/x86_64/lib && \
    mkdir -p ${VDB}/interfaces && cp -R /root/vdb/include/* ${VDB}/interfaces

# Build BLAST binaries
RUN curl -sS https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${blast_version}/ncbi-blast-${blast_version}+-src.tar.gz | \
 tar xzf - && \
 cd ncbi-blast-${blast_version}+-src/c++ && \
 ./configure --with-mt --with-strip --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --with-openmp --with-vdb=${VDB} --without-gnutls --without-gcrypt --without-zstd --without-lzo --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j ${num_procs} -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe blastn_vdb.exe tblastn_vdb.exe blast_formatter_vdb.exe blast_vdb_cmd.exe blastdb_path.exe

FROM google/cloud-sdk:slim as gsutil
ARG blast_version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libgomp1 libnet-perl libxml-simple-perl libjson-perl perl-doc liblmdb-dev parallel vmtouch cpanminus curl && rm -rf /var/lib/apt/lists/*  && cpanm HTML::Entities

RUN mkdir -p /blast/bin /blast/lib
COPY --from=blastbuild /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=blastbuild /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/lib /blast/lib
COPY --from=blastbuild /root/VDB/linux/release/x86_64/lib /blast/lib

COPY --from=edirect /usr/local/ncbi/edirect /root/edirect

RUN mkdir -p /blast/blastdb /blast/blastdb_custom
RUN sed -i '$ a BLASTDB=/blast/blastdb:/blast/blastdb_custom' /etc/environment
ENV BLASTDB /blast/blastdb:/blast/blastdb_custom
ENV BLAST_DOCKER true
ENV PATH="/root/edirect:/blast/bin:${PATH}"

RUN cp  /blast/bin/blastp /blast/bin/blastp.REAL && \
    cp  /blast/bin/blastn /blast/bin/blastn.REAL && \
    cp  /blast/bin/blastx /blast/bin/blastx.REAL && \
    cp  /blast/bin/tblastn /blast/bin/tblastn.REAL && \
    cp  /blast/bin/tblastx /blast/bin/tblastx.REAL

COPY blastn.sh /blast/bin/blastn
COPY blastp.sh /blast/bin/blastp
COPY blastx.sh /blast/bin/blastx
COPY tblastn.sh /blast/bin/tblastn
COPY tblastx.sh /blast/bin/tblastx

RUN chmod +x /blast/bin/blastn && chmod +x /blast/bin/blastp && \
    chmod +x /blast/bin/blastx && chmod +x /blast/bin/tblastn && \
    chmod +x /blast/bin/tblastx


WORKDIR /blast

CMD ["/bin/bash"]

