# Official NCBI BLAST+ docker image

[NCBI BLAST+](http://blast.ncbi.nlm.nih.gov/) command line applications in a Docker image.

## Usage instructions

With this docker image one can run BLAST+ in an isolated container, facilitating reproducibility of BLAST results. As a user of this docker image, you are expected to provide BLAST databases and query sequence(s) to run BLAST as well as a location outside the container to save the results. One way to accomplish this is to use [Docker bind mounts](https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount).
Additional versions are [available](https://hub.docker.com/r/christiam/blast/tags/) and can be accessed via tags. Please note that we only support the last 3 versions of BLAST (FIXME).
Please see examples below.

### Show the latest version of blastn

  `docker run --rm christiam/blast blastn -version`

### Install NCBI-provided BLAST databases

  ```bash
  docker run --rm \
    -v $BLASTDB:/blast/blastdb:rw \
    -w /blast/blastdb \
    christiam/blast \
    update_blastdb.pl --decompress  --passive vector
  ```

### Show available BLAST databases in the $BLASTDB path on the local machine

  ```bash
  docker run --rm \
    -v $BLASTDB:/blast/blastdb:ro \
    christiam/blast \
    blastdbcmd -list /blast/blastdb -remove_redundant_dbs
  ```

### Use a previous version of BLAST+

  `docker run --rm christiam/blast:2.7.1 blastn -version`

## Use cases

### Data provisioning
#### I have my queries/BLASTDB locally
#### I have my queries/BLASTDB on GCS/S3
TODO: set up docker volume to access data

### Saving results

### Interactive

### Scripts
