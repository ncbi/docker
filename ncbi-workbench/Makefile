# Makefile for building a container with NCBI tools
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Wed 12 Dec 2018 05:06:03 PM EST

SHELL=/bin/bash
.PHONY: all clean build-gcp build-ncbi publish

USERNAME?=ncbi
IMG=workbench
VERSION?=0.1

build:
	docker build --build-arg version=${VERSION} -t ${USERNAME}/${IMG}:${VERSION} .
	docker tag ${USERNAME}/${IMG}:${VERSION} ${USERNAME}/${IMG}:latest

publish: build
	docker push ${USERNAME}/${IMG}:${VERSION}
	docker push ${USERNAME}/${IMG}:latest

clean:
	docker image rm ${USERNAME}/${IMG} ${USERNAME}/${IMG}:${VERSION}

check:
	./test.sh ${USERNAME}/${IMG}:${VERSION}
