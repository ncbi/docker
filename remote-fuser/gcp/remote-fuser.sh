#!/bin/bash
# gcp/remote-fuser.sh: Simple wrapper script around remote-fuser to fetch the
# latest BLAST databases in GCS
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu 06 Dec 2018 05:43:05 PM EST

export PATH=/bin:/usr/bin
#set -uo pipefail
shopt -s nullglob

BLASTDB_BUCKET=${1:-"blast-db"}
LOGFILE=/var/log/remote-fuser.log
BLASTDB_VERSION=`curl -s https://storage.googleapis.com/${BLASTDB_BUCKET}/latest-dir`
FUSE_CFG=https://storage.googleapis.com/${BLASTDB_BUCKET}/${BLASTDB_VERSION}/fuse.xml
MOUNT_DBS=/blast/blastdb
MOUNT_CACHE=/blast/cache
trap "/sbin/remote-fuser -u -m ${MOUNT_DBS} ; fusermount -uq ${MOUNT_DBS} " TERM INT QUIT EXIT HUP KILL ALRM

/sbin/remote-fuser --allow-all-certs -o allow_other -o kernel_cache -B 8 -x ${FUSE_CFG} -m ${MOUNT_DBS} -e ${MOUNT_CACHE} -b http://blast.ncbi.nlm.nih.gov/blast/bdb4cloud.cgi?version=%s -c 30 -f -l ${LOGFILE} -L info
