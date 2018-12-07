# remote-fuser Docker image

This Docker image facilitates FUSE access to NCBI provided BLAST databases.

## Usage

There are two Docker images:

| Docker image                   | Data source | Available BLAST databases                | Optimal use case |
|--------------------------------|-------------|------------------------------------------|------------------|
|[`ncbi/blastdb-remote-fuser-ncbi`][3]| NCBI        | See [here][cloud-blastdbs-from-ncbi]     | Operate in any environment |
|[`ncbi/blastdb-remote-fuser-gcp`][4] | GCS         | See [here][cloud-blastdbs-from-gcp]      | Operate in GCP |

*Note*: These data are stored in data centers near the northeastern coast of
the United States. Please consider starting your cloud instances in a region
that is as geographically close as possible to this region to reduce data
tranfer times.

In the command line below, `${LOG_DIR}` is an environment variable with the
value of a directory on the local host to store the log files from
remote-fuser.

Similarly, `${BLASTDB_DIR}` is an environment variable with the value of a directory 
on the local host to store the BLAST databases. 

```bash
docker run -dti --rm \
    --privileged --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor=unconfined \
    -v ${LOG_DIR}:/var/log:shared \
    -v ${BLASTDB_DIR}:/blast:shared \
    ncbi/blastdb-remote-fuser-ncbi
```

To stop the container, please run the command below:

```bash
docker stop `docker ps -f ancestor=ncbi/blastdb-remote-fuser-ncbi -f status=running -q`

```

## Maintainer's notes

Build image `make all`, check using either `make check` or `check-on-cos.sh`
(which requires publishing the image, run `make publish USERNAME=${YOUR_USERNAME_HERE}` 
for that). Note that on a COS node, `make` is not available.

To start/stop a COS instance, use the `make cos_start` and `make cos_stop` commands.

[cloud-blastdbs-from-ncbi]: https://ncbi.github.io/blast-cloud/blastdb/available-blastdbs.html
[cloud-blastdbs-from-gcp]: https://ncbi.github.io/blast-cloud/blastdb/available-blastdbs-gcp.html
[3]: https://hub.docker.com/r/ncbi/blastdb-remote-fuser-gcp/
[4]: https://hub.docker.com/r/ncbi/blastdb-remote-fuser-ncbi/
