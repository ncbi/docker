FROM ubuntu:17.10 as hmmerbuild

ARG VERSION

USER root
WORKDIR /root/


RUN apt-get -y -m update && apt-get install -y build-essential wget

RUN wget http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz
RUN tar xvf hmmer-3.1b2.tar.gz


WORKDIR /root/hmmer-3.1b2
RUN ./configure --enable-portable-binary --prefix=/hmmer && make && make install
WORKDIR easel
RUN make install

FROM ubuntu:17.10

COPY VERSION .

USER root
COPY --from=hmmerbuild /hmmer/bin /hmmer/bin

WORKDIR /hmmer/hmmerdb
ENV HMMERDB=/hmmer/hmmerdb
ENV PATH="/hmmer/bin:${PATH}"

CMD ["/bin/bash"]

