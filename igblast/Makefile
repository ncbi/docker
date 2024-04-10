SHELL=/bin/bash
.PHONY: all clean build publish check

USERNAME?=ncbi
IMG=igblast
VERSION?=1.22.0

build:
	docker build --build-arg version=${VERSION} -t ${USERNAME}/${IMG}:${VERSION} .
	docker tag ${USERNAME}/${IMG}:${VERSION} ${USERNAME}/${IMG}:latest

publish: build
	docker push ${USERNAME}/${IMG}:${VERSION}
	docker push ${USERNAME}/${IMG}:latest

clean:
	docker image rm ${USERNAME}/${IMG} ${USERNAME}/${IMG}:${VERSION}

check:
	docker run --rm ${USERNAME}/${IMG} igblastn -version
