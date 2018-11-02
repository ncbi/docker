# Official NCBI BLAST+ docker image

[NCBI BLAST+][1] command line applications in a Docker image.

# Usage instructions

With this docker image one can run BLAST+ in an isolated container, facilitating reproducibility of BLAST results. 
As a user of this docker image, you are expected to provide BLAST databases and query sequence(s) to run BLAST and a means to save the results.
Please see example usages below.

Show the latest version of blastn:

  `docker run --rm -it christiam/blast blastn -version`

Install NCBI-provided BLAST databases:

  `docker run --rm -it -v $BLASTDB:/blast/blastdb:rw -w /blast/blastdb christiam/blast update_blastdb.pl --decompress  --passive vector`

Show available BLAST databases in the $BLASTDB path on the local machine:

  `docker run --rm -it -v $BLASTDB:/blast/blastdb christiam/blast blastdbcmd -list /blast/blastdb -remove_redundant_dbs

Additional versions are [available](https://hub.docker.com/r/christiam/blast/tags/) and can be accessed via tags, e.g.:

  `docker run --rm -it christiam/blast:2.7.1 blastn -version`

## Use cases

### Data provisioning
#### I have my queries/BLASTDB locally
#### I have my queries/BLASTDB on GCS/S3
TODO: set up docker volume to access data

### Saving results

### Interactive

### Scripts

[1]: http://blast.ncbi.nlm.nih.gov/
