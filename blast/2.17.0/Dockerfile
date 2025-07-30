FROM ncbi/edirect:20.6 as edirect
FROM ubuntu:22.04
ARG blast_version
ARG vdb_version
ARG num_procs=8
ARG CLOUD_SDK_VERSION=472.0.0
LABEL Description="NCBI BLAST" Vendor="NCBI/NLM/NIH" Version=${blast_version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/
RUN mkdir -p /blast/bin /blast/lib

RUN apt-get -y -m update && apt-get install -y build-essential curl libidn12 libnet-perl perl-doc liblmdb-dev wget libsqlite3-dev cmake \
    libgomp1 libxml-simple-perl libjson-perl parallel vmtouch cpanminus python3 python3-openssl zlib1g-dev libzstd-dev libbz2-dev && \
    rm -fr /var/lib/apt/lists/*  && \
    cpanm HTML::Entities && rm -fr .cpanm

# Download and build ncbi-vdb
RUN wget -q https://github.com/ncbi/ncbi-vdb/archive/refs/tags/${vdb_version}.tar.gz && \
    tar xfz ${vdb_version}.tar.gz && rm ${vdb_version}.tar.gz && \
    mv ncbi-vdb-${vdb_version} ncbi-vdb && \
    cd ncbi-vdb && ./configure --prefix /root/vdb && make install -j ${num_procs} && \
    rm -fr ncbi-outdir

# For debugging
#RUN ldd --version

# Arrange ncbi-vdb libraries and header files in a form that C++ toolkit
# build can consume them.
ARG VDB=/root/VDB
RUN mkdir -p ${VDB}/linux/release/x86_64/lib && \
    cp -R /root/vdb/lib64/* ${VDB}/linux/release/x86_64/lib && \
    cp -R /root/vdb/lib64/* /blast/lib/ && \
    mkdir -p ${VDB}/interfaces && cp -R /root/vdb/include/* ${VDB}/interfaces

# Build BLAST binaries
RUN curl -sS -H 'Cache-Control: no-cache, no-store' https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${blast_version}/ncbi-blast-${blast_version}+-src.tar.gz | \
 tar xzf - && \
 cd ncbi-blast-${blast_version}+-src/c++ && \
 ./configure --with-mt --with-strip --with-optimization --with-dll --with-experimental=Int8GI --with-flat-makefile --with-openmp --with-sqlite3 --with-vdb=${VDB} --without-gnutls --without-gcrypt --without-lzo --with-z --with-zstd --with-bz2  --prefix=/blast && \
 cd ReleaseMT/build && \
 make -j ${num_procs} -f Makefile.flat blastdb_aliastool.exe blastdbcheck.exe blastdbcmd.exe blast_formatter.exe blastn.exe blastp.exe blastx.exe convert2blastmask.exe deltablast.exe dustmasker.exe makeblastdb.exe makembindex.exe makeprofiledb.exe psiblast.exe rpsblast.exe rpstblastn.exe segmasker.exe tblastn.exe tblastx.exe windowmasker.exe blastn_vdb.exe tblastn_vdb.exe blast_formatter_vdb.exe blast_vdb_cmd.exe blastdb_path.exe && \
 find /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT && \
 cp -pv /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/bin/*blast* /blast/bin/ && \
 cp -pv /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/bin/*masker /blast/bin/ && \
 cp -pv /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/bin/makembindex /blast/bin/ && \
 cp -pv /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/bin/makeprofiledb /blast/bin/ && \
 cp -pv /root/ncbi-blast-${blast_version}+-src/c++/ReleaseMT/lib/* /blast/lib/  && \
 rm -fr /root/ncbi-blast-${blast_version}+-src /root/ncbi-outdir

# For debugging
#RUN ldd --version

COPY --from=edirect /home/docker/edirect /root/edirect
COPY --from=edirect /home/docker/installconfirm /root/edirect

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

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV PATH /root/google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON=/usr/bin/python3
RUN ARCH=x86_64 && \
    curl -s -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    tar xzf google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    rm google-cloud-cli-${CLOUD_SDK_VERSION}-linux-${ARCH}.tar.gz && \
    rm -rf google-cloud-sdk/platform/bundledpythonunix && \
    gcloud components remove -q bq && \
    rm -fr $(find google-cloud-sdk/ -regex ".*/__pycache__") && \
    rm -rf google-cloud-sdk/.install/.backup && \
    rm -fr google-cloud-sdk/bin/anthoscli && \
	rm -fr google-cloud-sdk/lib/third_party/{botocore,kubernetes} && \
	rm -fr google-cloud-sdk/lib/googlecloudsdk/generated_clients/apis/compute/{alpha,beta} && \
	rm -fr google-cloud-sdk/lib/googlecloudsdk/generated_clients/apis/{healthcare,gkehub,cloudbuild,containeranalysis,dialogflow,aiplatform} && \
	rm -fr google-cloud-sdk/lib/surface && \
	rm -fr $(find google-cloud-sdk/ -name doc -o -name docs) && \
	gsutil --version && \
	gsutil ls gs://blast-db
ENV PATH /root/google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON=/usr/bin/python3


WORKDIR /blast

CMD ["/bin/bash"]

