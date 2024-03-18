FROM ubuntu:22.04 as blastbuild
ARG version=1.7.2
ARG vdb_version=3.0.7
ARG num_procs=8
LABEL Description="NCBI MagicBLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=boratyng@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl wget libxml2-dev libgomp1 cmake && rm -rf /var/lib/apt/lists/*


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


# Build Magic-BLAST
RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/${version}/ncbi-magicblast-${version}-src.tar.gz | \
 tar zxf - && \
 cd ncbi-magicblast-${version}-src/c++ && \
 ./configure --with-mt --with-strip --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --with-vdb=${VDB} --with-openmp --without-gnutls --without-gcrypt --without-zstd --without-lzo --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j ${num_procs} -f Makefile.flat magicblast.exe makeblastdb.exe

FROM ubuntu:22.04
ARG version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libxml2-dev libgomp1 ca-certificates && \
   rm -rf /var/lib/apt/lists/*

RUN mkdir -p /blast/bin /blast/lib

COPY --from=blastbuild /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/lib /blast/lib
COPY --from=blastbuild /root/VDB/linux/release/x86_64/lib /blast/lib
COPY --from=blastbuild /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/bin /blast/bin

RUN mkdir -p /blast/blastdb /blast/blastdb_custom
RUN sed -i '$ a BLASTDB=/blast/blastdb:/blast/blastdb_custom' /etc/environment
ENV BLASTDB /blast/blastdb:/blast/blastdb_custom
ENV PATH "/blast/bin:${PATH}"

WORKDIR /blast

CMD ["/bin/bash"]

