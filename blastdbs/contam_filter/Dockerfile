# Set the base image to Ubuntu
FROM ncbi/blast:2.7.1

COPY VERSION .

USER root

RUN apt-get -y -m update && apt-get install -y gawk

# get and setup blast applications                                
COPY binaries /usr/bin
RUN chmod 755 /usr/bin/vecscreen && chown root:root /usr/bin/vecscreen
RUN chmod 755 /usr/bin/VSlistTo1HitPerLine.awk && chown root:root /usr/bin/VSlistTo1HitPerLine.awk

WORKDIR ${BLASTDB}

COPY databases ${BLASTDB}

RUN gzip -d contam_in_euks.fa.gz \
    && makeblastdb -in contam_in_euks.fa -dbtype nucl \
    && makeblastdb -in contam_in_prok.fa -dbtype nucl \
    && makeblastdb -in contam_in_euks.fa -dbtype nucl \
    && makeblastdb -in adaptors_for_screening_proks.fa -dbtype nucl \
    && makeblastdb -in adaptors_for_screening_euks.fa -dbtype nucl \
    && gzip -d mito.nt.gz \
    && makeblastdb -in mito.nt -dbtype nucl \
    && gzip -d rrna.gz \
    && makeblastdb -in rrna -dbtype nucl \
    && makeblastdb -in UniVec -dbtype nucl

CMD ["/bin/sh"]
