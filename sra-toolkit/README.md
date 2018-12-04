# Docker container for NCBI SRA toolkit

## Maintainer's notes

A `Makefile` is provided to conveniently maintain this docker image. In the commands below, the value of `$X` represents the version of the SRA toolkit to base this image on.

* `make build VERSION=$X`: builds the docker image
* `make publish VERSION=$X`: publishes the image to Docker Hub
* `make check`: performs a sanity check on the most recently build image
