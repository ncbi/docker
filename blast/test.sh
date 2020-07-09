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


SCRIPT_DIR=$(cd "`dirname "$0"`"; pwd)
TMP=`mktemp -dp $SCRIPT_DIR/`  # Creates tmp directory 
trap " /bin/rm -fr $TMP " INT QUIT EXIT HUP KILL ALRM

time docker run --rm ${IMG} /bin/bash -c "printenv BLASTDB"

time docker run --rm ${IMG} blastn -version
time docker run --rm ${IMG} installconfirm
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} efetch -db nucleotide -id u00001 -format fasta | tee $TMP/u00001.fna
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} makeblastdb -in u00001.fna -dbtype nucl -out test-blastdb -title TEST
time docker run --rm -v $TMP:/blast/blastdb:rw ${IMG} blastdbcmd -info -db test-blastdb
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} blastn -query u00001.fna -db test-blastdb -outfmt 6 | tee $TMP/blastn.out
NUM_LINES=`wc -l $TMP/blastn.out | cut -f 1 -d ' '`
[ $NUM_LINES -eq 1 ] || "BLASTn search failed!"

time docker run --rm ${IMG} gsutil --version

time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} update_blastdb.pl --decompress --passive $DB
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} update_blastdb.pl --decompress $DB
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} update_blastdb.pl --decompress --source gcp $DB
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} update_blastdb.pl --decompress --passive --source gcp $DB
time docker run --rm -v $TMP:/blast/blastdb:rw -w /blast/blastdb ${IMG} update_blastdb.pl --decompress --passive --source gcp $DB
ls -l $TMP

time docker run --rm ${IMG} get_species_taxids.sh -n squirrel
