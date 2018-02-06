FROM ncbi/blast:18.02 as etl

USER root
WORKDIR /tarballs

COPY tarballs /tarballs

RUN for i in *.tar.gz; do tar xvf ${i} -C ${BLASTDB} && rm ${i}; done

FROM ncbi/blast:18.02

COPY VERSION .

USER root

WORKDIR ${BLASTDB}

COPY --from=etl ${BLASTDB} ${BLASTDB}/.

CMD ["/bin/sh"]
