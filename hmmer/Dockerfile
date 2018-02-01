FROM ubuntu:16.04 as hmmerbuild

ARG VERSION

USER root
WORKDIR /root/


RUN apt-get -y -m update && apt-get install -y build-essential wget

#COPY hmmer-3.1b2.tar.gz /root
RUN wget http://eddylab.org/software/hmmer3/${VERSION}/hmmer-${VERSION}.tar.gz
RUN tar xvf hmmer-${VERSION}.tar.gz


WORKDIR /root/hmmer-${VERSION}
RUN ./configure --enable-portable-binary --prefix=/hmmer && make && make install
WORKDIR easel
RUN make install

FROM ubuntu:16.04

COPY VERSION .

USER root
COPY --from=hmmerbuild /hmmer/bin /hmmer/bin

WORKDIR /hmmer/hmmerdb
ENV PATH="/hmmer/bin:${PATH}"

CMD ["/bin/bash"]

