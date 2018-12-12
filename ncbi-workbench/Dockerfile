FROM christiam/sra-toolkit as srat
FROM ncbi/blast-workbench

LABEL Description="NCBI tools" \
    Vendor="NCBI/NLM/NIH" \
    URL="https://www.ncbi.nlm.nih.gov" \
    Maintainer=camacho@ncbi.nlm.nih.gov 

COPY --from=srat /usr/local/ncbi/sra-toolkit /usr/local/ncbi/sra-toolkit
RUN apt-get -y -m update && apt-get install -y \
    libidn11 fuse && \
    rm -rf /var/lib/apt/lists/*

ENV PATH "/usr/local/ncbi/sra-toolkit/bin:${PATH}"
ENV BLASTDB "/blast/blastdb:/blast/blastdb_custom"
CMD ["/bin/bash"]
