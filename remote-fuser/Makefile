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

all: build-gcp build-ncbi

build-ncbi: remote-fuser.tgz
	tar -xvC ncbi -f $^ remote-fuser remote-fuser-ctl.ini remote-fuser-ctl.pl
	docker build -t ${USERNAME}/${IMG_NCBI}:${VERSION} ncbi
	docker tag ${USERNAME}/${IMG_NCBI}:${VERSION} ${USERNAME}/${IMG_NCBI}:latest

build-gcp: remote-fuser.tgz
	tar -xvC gcp -f $^ remote-fuser
	docker build -t ${USERNAME}/${IMG_GCP}:${VERSION} gcp
	docker tag ${USERNAME}/${IMG_GCP}:${VERSION} ${USERNAME}/${IMG_GCP}:latest

remote-fuser.tgz:
	curl -sO ftp://ftp.ncbi.nlm.nih.gov/blast/executables/remote-fuser/remote-fuser.tgz

publish: all
	docker push ${USERNAME}/${IMG_NCBI}:${VERSION}
	#docker push ${USERNAME}/${IMG_NCBI}:latest
	docker push ${USERNAME}/${IMG_GCP}:${VERSION}
	#docker push ${USERNAME}/${IMG_GCP}:latest

clean:
	docker image rm ${USERNAME}/${IMG_NCBI}
	docker image rm ${USERNAME}/${IMG_GCP}

###########################
.PHONY: stop
check: stop
	bash -x check-on-cos.sh ${VERSION}

stop:
	-docker stop ${IMG_NCBI} ${IMG_GCP}
	-rm -fr blastdb_* logs_*

####################################
# COS
.PHONY: cos_start cos_stop

TYPE?=n1-standard-8
ZONE?=us-east4-b
VM_IMG?=cos-stable-70-11021-99-0
cos_start:
	@[ ! -z "${GCP_PRJ}" ] || \
		{ echo "Please define GCP_PRJ environment variable"; exit 1; }
	gcloud compute instances create rmt-fuser-test-${USER} \
		--machine-type ${TYPE} \
		--image ${VM_IMG} \
		--image-project=cos-cloud \
        --scopes cloud-platform \
        --project ${GCP_PRJ} \
		--zone ${ZONE}

cos_stop:
	@[ ! -z "${GCP_PRJ}" ] || \
		{ echo "Please define GCP_PRJ environment variable"; exit 1; }
	gcloud compute instances delete rmt-fuser-test-${USER} --project ${GCP_PRJ} --zone ${ZONE}

