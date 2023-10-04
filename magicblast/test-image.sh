#!/bin/bash -xe

mkdir -p db
echo NZ_DS499579.1 >db/subject
docker run --rm -v $(pwd)/db:/blast/blastdb:rw \
	-v /etc/ssl/certs:/etc/ssl/certs:ro \
	ncbi/magicblast magicblast -sra SRR000066 \
	-subject /blast/blastdb/subject -out /blast/blastdb/out.sam

