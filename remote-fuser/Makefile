# Makefile for building remote-fuser containers pre-configured to fetch data from
# NCBI and GCP.
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Mon 03 Dec 2018 06:59:34 PM EST

SHELL=/bin/bash
.PHONY: all clean build-gcp build-ncbi publish

USERNAME?=ncbi
IMG_GCP=blastdb-remote-fuser-gcp
IMG_NCBI=blastdb-remote-fuser-ncbi
VERSION?=0.1

all: build-gcp

# N.B.: Order in which the targets are run matters!
build-ncbi: remote-fuser-ctl.ini
	docker build --build-arg source=NCBI -t ${USERNAME}/${IMG_NCBI}:${VERSION} .
	docker tag ${USERNAME}/${IMG_NCBI}:${VERSION} ${USERNAME}/${IMG_NCBI}:latest

build-gcp: build-ncbi
	head -20 ./config-gcs-access.sh > tmp.sh
	chmod +x tmp.sh
	./tmp.sh
	docker build --build-arg source=GCP -t ${USERNAME}/${IMG_GCP}:${VERSION} .
	docker tag ${USERNAME}/${IMG_GCP}:${VERSION} ${USERNAME}/${IMG_GCP}:latest

# This also brings remote-fuser-ctl.pl
remote-fuser-ctl.ini:
	curl -s ftp://ftp.ncbi.nlm.nih.gov/blast/executables/remote-fuser/remote-fuser.tgz | tar -zxf -

publish: all
	docker push ${USERNAME}/${IMG_NCBI}:${VERSION}
	docker push ${USERNAME}/${IMG_NCBI}:latest
	docker push ${USERNAME}/${IMG_GCP}:${VERSION}
	docker push ${USERNAME}/${IMG_GCP}:latest

clean:
	docker image rm ${USERNAME}/${IMG_NCBI}
	docker image rm ${USERNAME}/${IMG_GCP}
	${RM} config-gcs-access.sh README.txt tmp.sh

###########################
.PHONY: stop
check: stop
	[ -d logs1 ] || mkdir logs1
	[ -d blastdb1 ] || mkdir blastdb1
	[ -d logs2 ] || mkdir logs2
	[ -d blastdb2 ] || mkdir blastdb2
	docker run -dti --rm --name ${IMG_NCBI} \
		--privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
		--mount type=bind,src=${PWD}/logs1,dst=/var/log,bind-propagation=shared \
		--mount type=bind,src=${PWD}/blastdb1,dst=/blast,bind-propagation=shared \
		${USERNAME}/${IMG_NCBI}
	docker run -dti --rm --name ${IMG_GCP} \
		--privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
		--mount type=bind,src=${PWD}/logs2,dst=/var/log,bind-propagation=shared \
		--mount type=bind,src=${PWD}/blastdb2,dst=/blast,bind-propagation=shared \
		${USERNAME}/${IMG_GCP}
	sleep 1
	docker exec -ti ${IMG_NCBI} ps aux | grep remote-fuser
	docker exec -ti ${IMG_GCP} ps aux | grep remote-fuser

stop:
	-docker stop ${IMG_NCBI} ${IMG_GCP}
	-sudo rm -fr blastdb[12] logs[12]
