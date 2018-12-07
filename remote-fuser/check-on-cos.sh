#!/bin/bash
# check-on-cos.sh: Perform some sanity checks on remote-fuser docker image on
# COS environment.
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Thu 06 Dec 2018 11:54:03 AM EST

export PATH=/bin:/usr/bin
set -euo pipefail
shopt -s nullglob

VERSION=${1:-"latest"}
USERNAME=ncbi
IMG_GCP=blastdb-remote-fuser-gcp
IMG_NCBI=blastdb-remote-fuser-ncbi

trap "docker stop ${IMG_NCBI} ${IMG_GCP}; docker rm ${IMG_NCBI} ${IMG_GCP}; /bin/rm -fr logs_* blastdb_*" INT QUIT EXIT HUP KILL ALRM

rm -fr logs_* blastdb_*
mkdir logs_ncbi logs_gcp blastdb_ncbi blastdb_gcp
#docker run -dti --name ${IMG_NCBI} \
#    --privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
#    --mount type=bind,src=${PWD}/logs_ncbi,dst=/var/log,bind-propagation=shared \
#    --mount type=bind,src=${PWD}/blastdb_ncbi,dst=/blast,bind-propagation=shared \
#    ${USERNAME}/${IMG_NCBI}:${VERSION}
#docker run -dti --name ${IMG_GCP} \
#    --privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
#    --mount type=bind,src=${PWD}/logs_gcp,dst=/var/log,bind-propagation=shared \
#    --mount type=bind,src=${PWD}/blastdb_gcp,dst=/blast,bind-propagation=shared \
#    ${USERNAME}/${IMG_GCP}:${VERSION}
docker run -dti --name ${IMG_NCBI} \
    --privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
    -v ${PWD}/logs_ncbi:/var/log:shared \
    -v ${PWD}/blastdb_ncbi:/blast:shared \
    ${USERNAME}/${IMG_NCBI}:${VERSION}
docker run -dti --name ${IMG_GCP} \
    --privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
    -v ${PWD}/logs_gcp:/var/log:shared \
    -v ${PWD}/blastdb_gcp:/blast:shared \
    ${USERNAME}/${IMG_GCP}:${VERSION}

sleep 3;
docker ps

# Check outside the container
docker logs ${IMG_NCBI}
docker logs ${IMG_GCP}
tail logs_*/remote-fuser.log
for f in blastdb_*/blastdb/nr*pal; do ls -l $f; cat -n $f ; done
# Check inside the container
docker exec -ti ${IMG_NCBI} sh -c "ps aux && ls -l /blast/blastdb/nr*pal && cat -n /blast/blastdb/nr*pal"
docker exec -ti ${IMG_GCP}  sh -c "ps aux && ls -l /blast/blastdb/nr*pal && cat -n /blast/blastdb/nr*pal"
