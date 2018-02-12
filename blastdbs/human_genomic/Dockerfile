FROM ncbi/blast:18.02 as etl

USER root
WORKDIR /tarballs

RUN apt-get -y -m update && apt-get install -y wget curl

#COPY tarballs /tarballs
RUN curl -s -l ftp://ftp.ncbi.nlm.nih.gov/blast/db/ | grep ^human_genomic\..*\.tar\.gz$ > tarfiles.txt
RUN while read i; do wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/db/${i}; done < tarfiles.txt
RUN while read i; do tar xvf ${i} -C ${BLASTDB}; done < tarfiles.txt

FROM ncbi/blast:18.02

COPY VERSION .

USER root

WORKDIR ${BLASTDB}

# Do this to break the image into more managable layers.
COPY --from=etl ${BLASTDB}/human_genomic.0[0-4].* ${BLASTDB}/
COPY --from=etl ${BLASTDB}/human_genomic.0[5-9].* ${BLASTDB}/
COPY --from=etl ${BLASTDB}/human_genomic.1[0-4].* ${BLASTDB}/
COPY --from=etl ${BLASTDB}/human_genomic.1[5-9].* ${BLASTDB}/
COPY --from=etl ${BLASTDB}/human_genomic.2[0-4].* ${BLASTDB}/
#COPY --from=etl ${BLASTDB}/human_genomic.2[5-9].* ${BLASTDB}/

CMD ["/bin/sh"]
