#!/bin/bash -x
# t.sh: simple test script 
#
# Author: Christiam Camacho (christiam.camacho@gmail.com)
# Created: Sat Nov  3 08:44:39 2018

docker run --rm christiam/blast-workbench /bin/bash -c "printenv BLASTDB"
docker run --rm christiam/blast-workbench /bin/bash -c "ls -hl /blast/bin /blast/lib"
docker run --rm christiam/blast-workbench /bin/bash -c "ls -hl /magicblast/bin /magicblast/lib"
docker run --rm christiam/blast-workbench /bin/bash -c "ldd /magicblast/bin/magicblast"
docker run --rm christiam/blast-workbench /bin/bash -c "ldd /blast/bin/blastdbcmd"
docker run --rm christiam/blast-workbench blastn -version
docker run --rm -w /blast/lib christiam/blast-workbench blastn -version
docker run --rm christiam/blast-workbench magicblast -version
docker run --rm -w /magicblast/lib christiam/blast-workbench magicblast -version
docker run --rm christiam/blast-workbench installconfirm
docker run --rm christiam/blast-workbench /bin/sh -c " esearch -db nucleotide -query u00001 | efetch -format fasta"
