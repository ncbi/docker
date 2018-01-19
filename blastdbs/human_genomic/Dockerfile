# Set the base image to Ubuntu
FROM slottad/blast:2.7.1

COPY VERSION .

USER root

WORKDIR ${BLASTDB}

COPY databases /var/db/blast

CMD ["/bin/sh"]
