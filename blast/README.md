# Official NCBI BLAST+ Docker image

[NCBI BLAST+](http://blast.ncbi.nlm.nih.gov/) command line applications in a Docker image.

# Supported tags and respective Dockerfile links
* [2.8.0](https://github.com/christiam/docker/blob/support-more-versions/blast/2.8.0/Dockerfile): [release notes](https://www.ncbi.nlm.nih.gov/books/NBK131777/#_Blast_ReleaseNotes_BLAST_2_8_0_March_28_)
* [2.7.1](https://github.com/christiam/docker/blob/support-more-versions/blast/2.7.1/Dockerfile): [release notes](https://www.ncbi.nlm.nih.gov/books/NBK131777/#_Blast_ReleaseNotes_BLAST_2_7_1_October_2_)

# Quick reference

## Where to get help with:

BLAST: Check out the [BLAST+ Cookbook](https://www.ncbi.nlm.nih.gov/books/NBK279696/), consult the [BLAST Knowledge Base](https://support.nlm.nih.gov/knowledgebase/category/?id=CAT-01239), or email us at blast-help@ncbi.nlm.nih.gov.
Docker: [the Docker Community Forums](https://forums.docker.com), [the Docker Community Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/), or [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker+blast)

## Where to file issues:

Please email us at blast-help@ncbi.nlm.nih.gov.

## Maintained by:

[National Center for Biotechnology Information (NCBI)](https://blast.ncbi.nlm.nih.gov),
[National Library of Medicine (NLM)](https://www.nlm.nih.gov/),
[National Institutes of Health (NIH)](https://www.nih.gov/)

## Supported architectures

`amd64`


# What is NCBI BLAST?

The Basic Local Alignment Search Tool (BLAST) finds regions oflocal similarity between sequences. The program compare    s nucleotide or protein sequences to sequence databases and calculates the statistical significance of matches. BLAST can be used to infer functional and evolutionary relationships between sequences as well as help identify members of gene families.

![logo](https://www.nlm.nih.gov/about/logos_nlm_photos/large-White_ncbi_logo_200h.png)

With this Docker image one can run BLAST+ in an isolated container, facilitating reproducibility of BLAST results. As a user of this Docker image, you are expected to provide BLAST databases and query sequence(s) to run BLAST as well as a location outside the container to save the results. One way to accomplish this is to use [Docker bind mounts](https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount).
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

