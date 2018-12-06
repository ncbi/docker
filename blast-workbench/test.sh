#!/bin/bash -x
# test.sh: simple test script 
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Sat Nov  3 08:44:39 2018

IMG=ncbi/blast-workbench

time docker run --rm ${IMG} /bin/bash -c "printenv BLASTDB"
time docker run --rm ${IMG} blastn -version
time docker run --rm ${IMG} magicblast -version
time docker run --rm ${IMG} installconfirm
time docker run --rm ${IMG} efetch -db nucleotide -id u00001 -format fasta
time docker run --rm ${IMG} get_species_taxids.sh -n squirrel
time docker run --rm ${IMG} update_blastdb.pl --decompress taxdb
time docker run --rm ${IMG} update_blastdb.pl taxdb --source gcp
