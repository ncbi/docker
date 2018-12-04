# Makefile for building a container with the NCBI SRA toolkit
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Mon 03 Dec 2018 07:49:37 PM EST

SHELL=/bin/bash
.PHONY: all clean build-gcp build-ncbi publish

USERNAME?=ncbi
IMG=sra-toolkit
VERSION?=2.9.2

build:
	docker build --build-arg version=${VERSION} -t ${USERNAME}/${IMG}:${VERSION} .
	docker tag ${USERNAME}/${IMG}:${VERSION} ${USERNAME}/${IMG}:latest

publish: build
	docker push ${USERNAME}/${IMG}:${VERSION}
	docker push ${USERNAME}/${IMG}:latest

clean:
	docker image rm ${USERNAME}/${IMG} ${USERNAME}/${IMG}:${VERSION}

check:
	docker run -ti ${USERNAME}/${IMG} fastq-dump --stdout SRR390728 | head -n 8
