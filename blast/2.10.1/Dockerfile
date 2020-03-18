FROM ncbi/blast 
ARG version
ARG num_procs=8
LABEL Description="NCBI BLAST" Vendor="NCBI/NLM/NIH" Version=${version} Maintainer=camacho@ncbi.nlm.nih.gov

USER root
WORKDIR /root/

RUN apt-get -y -m update && apt-get install -y time
CMD ["/bin/bash"]

