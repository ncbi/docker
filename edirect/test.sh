#!/bin/bash
# test.sh: Perform some sanity checks on the edirect docker image
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Fri 07 Dec 2018 03:45:23 PM EST
IMG=${1:-"ncbi/edirect:latest"}
docker run --rm -it ${IMG} ./installconfirm
docker run --rm -it ${IMG} efetch -db nucleotide -id u00001 -format fasta
