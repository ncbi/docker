FROM ubuntu:16.04 as amrbuild

ARG VERSION

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y build-essential

COPY src src

WORKDIR src
RUN make

FROM ubuntu:16.04

COPY VERSION .

USER root
WORKDIR /root
COPY --from=amrbuild /root/src/amr_report /usr/bin

CMD ["/bin/bash"]

