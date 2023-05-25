FROM ubuntu:18.04
ARG version=1.21.0
LABEL Description="NCBI IgBLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=jianye@ncbi.nlm.nih.gov

USER root
WORKDIR /

RUN apt-get -y -m update && apt-get install -y curl libgomp1 libxml2-dev

RUN curl -s ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/${version}/ncbi-igblast-${version}-x64-linux.tar.gz | tar zxf - 

env IGDATA=/ncbi-igblast-${version}
env PATH "/ncbi-igblast-${version}/bin:${PATH}"

CMD ["/bin/sh"]
