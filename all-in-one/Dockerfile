FROM christiam/magicblast as magicblast
FROM christiam/edirect as edirect
FROM christiam/blast
RUN mkdir -p /magicblast/bin /magicblast/lib
COPY --from=magicblast /blast/bin/magicblast /magicblast/bin
COPY --from=magicblast /blast/lib /magicblast/lib
COPY --from=edirect /usr/local/ncbi/edirect /usr/local/ncbi/edirect
RUN apt-get -y -m update && apt-get install -y curl cpanminus libxml-simple-perl libwww-perl libnet-perl && rm -rf /var/lib/apt/lists/* && cpanm HTML::Entities
ENV LD_LIBRARY_PATH "/blast/lib:/magicblast/lib"
ENV PATH "/usr/local/ncbi/edirect:/blast/bin:/magicblast/bin:${PATH}"
ENV BLASTDB "/blast/blastdb:/blast/blastdb_custom"
CMD ["/bin/bash"]
