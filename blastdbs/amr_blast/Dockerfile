FROM ncbi/blast:18.02 as etl

USER root

WORKDIR ${BLASTDB}
COPY AMRProt ${BLASTDB}
RUN makeblastdb -in AMRProt -dbtype prot

FROM ncbi/blast:18.02

COPY VERSION .

USER root

WORKDIR ${BLASTDB}

COPY --from=etl ${BLASTDB} ${BLASTDB}/.

CMD ["/bin/sh"]
