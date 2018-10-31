# Official NCBI BLAST+ docker image

[NCBI BLAST+](http://blast.ncbi.nlm.nih.gov/) command line applications in a Docker image.

# Usage instructions

With this docker image one can run BLAST+ in an isolated container, facilitating reproducibility of BLAST results. 
As a user of this docker image, you are expected to provide BLAST databases and query sequence(s) to run BLAST and a means to save the results.

Please see example usages below.

  `docker run --rm -it -v $BLASTDB:/blast/blastdb ncbi/blast`

   This runs the latest version of BLAST+. Additional versions are [available](https://hub.docker.com/r/ncbi/blast/tags/) and can be accessed via tags, e.g.:

  `docker run --rm -it ncbi/blast:2.6.0 blastn -version`

## Use cases

### Data provisioning
#### I have my queries/BLASTDB locally
#### I have my queries/BLASTDB on GCS/S3
TODO: set up docker volume to access data

### Saving results

### Interactive

### Scripts

