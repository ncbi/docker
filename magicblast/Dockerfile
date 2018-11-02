FROM ubuntu:18.04
ARG version
ARG num_procs=8
LABEL Description="NCBI MagicBLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl libxml2-dev git && rm -rf /var/lib/apt/lists/*

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/${version}/ncbi-magicblast-${version}-src.tar.gz | \
 tar zxf - && \
 cd ncbi-magicblast-${version}-src/c++ && \
 ./configure --with-dll --with-experimental=Int8GI --with-flat-makefile --with-downloaded-vdb --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j ${num_procs} -f Makefile.flat magicblast.exe

FROM ubuntu:18.04
ARG version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libxml2-dev && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /blast/bin /blast/lib
COPY --from=0 /root/ncbi-magicblast-${version}-src/c++/local/ncbi-vdb-*/lib64 /blast/lib
COPY --from=0 /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/lib /blast/lib
COPY --from=0 /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/bin/magicblast /blast/bin

RUN mkdir -p /blast/blastdb /blast/blastdb_custom
RUN sed -i '$ a BLASTDB=/blast/blastdb:/blast/blastdb_custom' /etc/environment
ENV BLASTDB /blast/blastdb:/blast/blastdb_custom
ENV PATH "/blast/bin:${PATH}"

WORKDIR /blast

CMD ["/bin/bash"]

