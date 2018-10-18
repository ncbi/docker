ARG PGAP_VERSION
#FROM ncbi/pgap:${PGAP_VERSION} as pgtemp
FROM ubuntu:latest as pgtemp

USER root

WORKDIR /pgap

COPY *.tar.gz /pgap

RUN tar -xv --strip-components=1 -f *.tar.gz
RUN rm *.tar.gz
RUN rm -rf .git* 
#RUN rm -rf pgap-${PGAP_VERSION}/.git* 
#RUN mv pgap-${PGAP_VERSION}/* .
#RUN rmdir pgap-${PGAP_VERSION}

# COPY input*.tgz /pgap
# RUN tar xvf input-${PGAP_VERSION}.tgz
# RUN rm input-${PGAP_VERSION}.tgz

FROM ncbi/pgap:${PGAP_VERSION}

COPY --from=pgtemp /pgap /pgap/.

USER root

WORKDIR /pgap

RUN echo "ip_resolve=4" >> /etc/yum.conf
RUN yum -y update && yum -y install yum-utils && yum -y groupinstall development
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u python36u-pip python36u-devel nodejs
RUN pip3.6 install -U cwltool[deps] PyYAML cwlref-runner

RUN cat input.yaml MG37/input.yaml > mg37_input.yaml
RUN mkdir /pgap/input

CMD ["/bin/sh"]
