FROM centos:latest

COPY VERSION .

USER root
WORKDIR /root

RUN yum -y install libgomp curl ncbi-blast 

# install blast
RUN mkdir -p /blast/bin /blast/lib
COPY --from=amrbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/bin /blast/bin
COPY --from=amrbuild /root/ncbi-blast-2.7.1+-src/c++/ReleaseMT/lib /blast/lib
WORKDIR /blast/blastdb
ENV BLASTDB /blast/blastdb
ENV PATH="/blast/bin:${PATH}"

# install hmmer
COPY --from=amrbuild /hmmer/bin /hmmer/bin
WORKDIR /hmmer/hmmerdb
ENV HMMERDB=/hmmer/hmmerdb
ENV PATH="/hmmer/bin:${PATH}"

# install amr_report
RUN mkdir amr
WORKDIR amr
CMD curl -O https://raw.githubusercontent.com/ncbi/amr/master/.github/workflows/get_binary_release.sh 
RUN ./get_binary_release.sh

CMD ["/bin/bash"]
