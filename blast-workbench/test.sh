#!/bin/bash -x
# t.sh: simple test script 
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Sat Nov  3 08:44:39 2018

time docker run --rm christiam/blast-workbench /bin/bash -c "printenv BLASTDB"
time docker run --rm christiam/blast-workbench /bin/bash -c "ls -Srhl /blast/bin /blast/lib"
time docker run --rm christiam/blast-workbench /bin/bash -c "ls -Srhl /magicblast/bin /magicblast/lib"
#time docker run --rm christiam/blast-workbench /bin/bash -c "ldd /magicblast/bin/magicblast"
time docker run --rm christiam/blast-workbench /bin/bash -c "ldd /blast/bin/blastdbcmd"
time docker run --rm christiam/blast-workbench blastn -version
time docker run --rm -w /blast/lib christiam/blast-workbench blastn -version
time docker run --rm christiam/blast-workbench magicblast -version
time docker run --rm -w /magicblast/lib christiam/blast-workbench magicblast -version
time docker run --rm christiam/blast-workbench installconfirm
time docker run --rm christiam/blast-workbench /bin/sh -c " esearch -db nucleotide -query u00001 | efetch -format fasta"
time docker run --rm christiam/blast-workbench get_species_taxids.sh -n human
time docker run --rm christiam/blast-workbench update_blastdb.pl --passive --decompress taxdb
