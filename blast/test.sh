#!/bin/bash
# test.sh: Perform some sanity checks on the BLAST docker image
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Fri 07 Dec 2018 03:45:23 PM EST

export PATH=/bin:/usr/bin
set -uo pipefail
shopt -s nullglob

IMG=${1:-"ncbi/blast:latest"}
DB=taxdb

TMP=`mktemp -dp $SCRIPT_DIR/`  # Creates tmp directory 
trap " /bin/rm -fr $TMP " INT QUIT EXIT HUP KILL ALRM

docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb $IMG update_blastdb.pl --decompress --passive $DB
docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb $IMG update_blastdb.pl --decompress $DB
docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb $IMG update_blastdb.pl --decompress --source gcp $DB
docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb $IMG update_blastdb.pl --decompress --passive --source gcp $DB
