# blast-static

Tools to create a docker image with statically linked BLAST programs for Linux amd64 and arm64/v8 architectures.

To create a multi-architecture image:
1. Run `build-image.sh` script on an amd64 and arm64 machines to create and push the images with tags that end with `-amd64` and `-arm64`.
2. Run `create-multi-arch-image.sh`.

`create-multi-arch-image.sh` with default parameters creates an image tagged `blast-static:${VERSION}`. To create and push the image tagged `latest`, run:

```
create-multi-arch-image.sh ncbi latest
```
