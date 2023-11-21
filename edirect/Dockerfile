FROM ubuntu:20.04

ARG version
ARG username=docker
ARG grpname=docker

LABEL Description="NCBI EDirect"
LABEL Vendor="NCBI/NLM/NIH"
LABEL Version=${version}
LABEL Maintainer=camacho@ncbi.nlm.nih.gov

# needed to for tzdata package
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get -y -m update && \
    apt-get install -y curl libxml-simple-perl libwww-perl libnet-perl build-essential && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd ${grpname} && \
    useradd --no-log-init -r -g ${grpname} ${username} && \
    mkdir -vp /home/${username} && \
    chown -Rc ${username}:${grpname} /home/${username}

USER ${username}
WORKDIR /home/${username}/

RUN sh -c "$(curl -fsSL https://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"

COPY --chown=${username}:${grpname} installconfirm /home/${username}/

ENV PATH="/home/${username}/edirect:${PATH}"
ENV EMAIL=docker@ncbi.nlm.nih.gov

CMD ["/bin/bash"]

