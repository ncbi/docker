FROM ubuntu:18.04

ARG version

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential curl libxml2-dev

RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/${version}/ncbi-magicblast-${version}-src.tar.gz | \
 tar zxf - && \
 cd ncbi-magicblast-${version}-src/c++ && \
 ./configure --with-dll --with-experimental=Int8GI --with-flat-makefile --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j 32 -f Makefile.flat magicblast.exe

FROM ubuntu:18.04
ARG version
COPY VERSION .

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y libgomp1

RUN mkdir -p /blast/bin /blast/lib
COPY --from=0 /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/lib /blast/lib
COPY --from=0 /root/ncbi-magicblast-${version}-src/c++/ReleaseMT/bin /blast/bin

WORKDIR /blast/blastdb
ENV BLASTDB /blast/blastdb
ENV PATH="/blast/bin:${PATH}"

CMD ["/bin/bash"]

