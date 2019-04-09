# Official NCBI BLAST+ Docker image

[NCBI BLAST+](http://blast.ncbi.nlm.nih.gov/) command line applications in a Docker image.

## Table of Contents

   * [What is NCBI BLAST?](#what-is-ncbi-blast)
   * [How to use this image?](#how-to-use-this-image)
      * [Data provisioning](#data-provisioning)
         * [Install NCBI-provided BLAST databases](#install-ncbi-provided-blast-databases)
         * [Make and install my own BLAST databases](#make-and-install-my-own-blast-databases)
         * [Make query sequence(s) accessible in the Docker container](#make-query-sequences-accessible-in-the-docker-container)
         * [Show available BLAST databases on local host](#show-available-blast-databases-on-local-host)
         * [Show BLAST databases available for download from NCBI](#show-blast-databases-available-for-download-from-ncbi)
         * [Show BLAST databases available for download from GCP](#show-blast-databases-available-for-download-from-gcp)
      * [Running BLAST](#running-blast)
         * [Interactive BLAST](#interactive-blast)
         * [Scripted BLAST](#scripted-blast)
         * [Show the latest version of BLAST ](#show-the-latest-version-of-blast)
         * [Use a previous version of BLAST ](#use-a-previous-version-of-blast)
      * [Troubleshooting](#troubleshooting)
   * [Support](#support)
   * [License](#license)


# What is NCBI BLAST?

The Basic Local Alignment Search Tool (BLAST) finds regions of local
similarity between sequences. The program compares nucleotide or protein
sequences to sequence databases and calculates the statistical significance of
matches. BLAST can be used to infer functional and evolutionary relationships
between sequences as well as help identify members of gene families.

![logo](https://www.nlm.nih.gov/about/logos_nlm_photos/large-White_ncbi_logo_200h.png)

# How to use this image?

With this Docker image you can run BLAST+ in an isolated container,
facilitating reproducibility of BLAST results. As a user of this Docker image,
you are expected to provide BLAST databases and query sequence(s) to run BLAST
as well as a location outside the container to save the results. 

*NOTE*: The commands on this page will work on modern Linux and macos
distributions.

## Data provisioning

One way to provide data for the container is to make it available on the local
host and use [Docker bind mounts][docker-bind-mounts] to make these accessible
from the container. In the examples below, it is assumed that the following
directories exist and are writable by the user.

To create them, please run the following command: 

  ```bash 
  cd ; mkdir blastdb queries fasta results blastdb_custom
  ```

To populate these directories with sample data used in these examples, please
run the commands below:

  ```bash
  docker run --rm ncbi/blast efetch -db protein -format fasta \
    -id P01349 > $HOME/queries/P01349.fsa
  docker run --rm ncbi/blast efetch -db protein -format fasta \
    -id Q90523,P80049,P83981,P83982,P83983,P83977,P83984,P83985,P27950 \
    > $HOME/fasta/nurse-shark-proteins.fsa
  ```

For additional documentation on the `docker run` command, please see [its
documentation][docker-run-doc].


| Directory | Purpose | Notes |
| --------- | ------  | ----- |
| `$HOME/blastdb` | Stores NCBI provided BLAST databases | If set to a _single, absolute_ path, the `$BLASTDB` environment variable could be used instead (see [Configuring BLAST via environment variables][blast-manual-env-vars]). |
| `$HOME/queries` | Stores user provided query sequence(s) | |
| `$HOME/fasta`   | Stores user provided FASTA sequences to create BLAST database(s) | |
| `$HOME/results` | Stores BLAST results | Mount with `rw` permissions |
| `$HOME/blastdb_custom` | Stores user provided BLAST databases | |

### Install NCBI-provided BLAST databases

The following command will download the `swissprot_v5` BLAST database from
Google Cloud Platform (GCP) into `$HOME/blastdb` (notice the `-w` argument,
which sets the working directory for that command):

  ```bash
  docker run --rm \
    -v $HOME/blastdb:/blast/blastdb:rw \
    -w /blast/blastdb \
    ncbi/blast \
    update_blastdb.pl --source gcp swissprot_v5
  ```

### Make and install my own BLAST databases

If you have your own sequence data in a file called
`$HOME/fasta/sequences.fsa` and want to make a BLAST database, please run the
command below:

  ```bash
  docker run --rm \
    -v $HOME/blastdb_custom:/blast/blastdb_custom:rw \
    -v $HOME/fasta:/blast/fasta:ro \
    -w /blast/blastdb_custom \
    ncbi/blast \
    makeblastdb -in /blast/fasta/nurse-shark-proteins.fsa -dbtype prot \
    -parse_seqids -out nurse-shark-proteins -title "Nurse shark proteins" \
    -taxid 7801 -blastdb_version 5
  ```

To verify the newly created BLAST database above, one can run the command
below to display the accessions, sequence length and common name of the
sequences in the database:

  ```bash
  docker run --rm \
    -v $HOME/blastdb:/blast/blastdb:ro \
    -v $HOME/blastdb_custom:/blast/blastdb_custom:ro \
    ncbi/blast \
    blastdbcmd -entry all -db nurse-shark-proteins -outfmt "%a %l %C"
  ```

### Make query sequence(s) accessible in the Docker container

One way to make the query sequence data accessible in the container is to use
[Docker bind mounts][docker-bind-mounts]. For instance, assuming your query
sequences are stored in the `$HOME/queries` directory on the local host, you
can use the following parameter to `docker run` to make that directory
accessible inside the container in `/blast/queries` as a read-only directory:

  `-v $HOME/queries:/blast/queries:ro`.

### Show available BLAST databases on local host

The command below mounts the `$HOME/blastdb` path on the local machine as
`/blast/blastdb` on the container and `blastdbcmd` shows the available BLAST
databases at this location.

  ```bash
  docker run --rm \
    -v $HOME/blastdb:/blast/blastdb:ro \
    ncbi/blast \
    blastdbcmd -list /blast/blastdb -remove_redundant_dbs
  ```

### Show BLAST databases available for download from NCBI

  ```bash
  docker run --rm ncbi/blast update_blastdb.pl --showall --source ncbi
  ```

For instructions on how to download them, please [the documentation for update_blastdb.pl][update_blastdb_doc].

### Show BLAST databases available for download from GCP

*This feature is experimental*.

  ```bash
  docker run --rm ncbi/blast update_blastdb.pl --showall pretty --source gcp
  ```
For instructions on how to download them, please [the documentation for update_blastdb.pl][update_blastdb_doc].

## Running BLAST

When running BLAST in a Docker container, note the mounts specified to the
`docker run` command to make the input and outputs accessible. In the examples
below, the first two mounts provide access to the BLAST databases, the third
mount provides access to the query sequence(s) and the fourth mount provides a
directory to save the results (notice the `:ro` and `:rw` options which mount
the directories are read-only and read-write respectively).

### Interactive BLAST

__When to use__: This is useful for running a few (e.g.: less than 5-10) BLAST
searches on small BLAST databases where one expects the search to run in a few
seconds.

In this case one can login to the container and run BLAST commands inside the
container:

  ```bash
  docker run --rm -it \
    -v $HOME/blastdb:/blast/blastdb:ro -v $HOME/blastdb_custom:/blast/blastdb_custom:ro \
    -v $HOME/queries:/blast/queries:ro \
    -v $HOME/results:/blast/results:rw \
    ncbi/blast \
    /bin/bash
  ```

This will open a login shell in the container and one can run BLAST+ as if it
was locally installed.

### Scripted BLAST

__When to use__: This is a more practical approach if one has many (e.g.: 10 or
more) BLAST searches to run or these take a long time to execute.

In this case it may be better to start the blast container in
detached mode and execute commands on it. 

**NOTE**: Be sure to mount _all_ required directories, as these need to be
specified when the container is started.

  ```bash
  # Start a container named 'blast' in detached mode
  docker run --rm -dit --name blast \
    -v $HOME/blastdb:/blast/blastdb:ro -v $HOME/blastdb_custom:/blast/blastdb_custom:ro \
    -v $HOME/queries:/blast/queries:ro \
    -v $HOME/results:/blast/results:rw \
    ncbi/blast \
    sleep infinity

  # Check the container is running
  docker ps
  ```

To run a BLAST search in this container, one can issue the following command:

  ```bash
  docker exec blast blastp -query /blast/queries/P01349.fsa -db nurse-shark-proteins -out /blast/results/blastp.out
  ```
The results will be stored on the local host's `$HOME/results` directory.

To stop the container started in these examples run the command below:

  ```bash
  docker stop blast
  ```

For additional documentation on the `docker run` command, please see [its
documentation][docker-run-doc].

### Show the latest version of BLAST+

The command below shows how to display the latest BLAST version:

  ```bash
  # Create a new container, run the `blastn -version` command and immediately
  # remove the container image
  docker run --rm ncbi/blast blastn -version
  ```

### Use a previous version of BLAST+

Appending a tag to the image name (`ncbi/blast`) allows you to use a
different version of BLAST+ (see below for supported versions). For
example:

  `docker run --rm ncbi/blast:2.7.1 blastn -version`

## Troubleshooting

### I don't have docker installed!?!

You may have to check with your local system administrator, or install docker
yourself. In Ubuntu linux, you can run the commands below to do that:

  ```bash
  sudo snap install docker
  sudo apt install -y docker.io
  sudo usermod -aG docker $USER
  # Log out and log back in
  ```

### How do I check that docker will work?

Run the following command: `docker run --rm hello-world`.

If this command fails, you may not have docker installed or permissions to run
docker. 


# Support

## Supported tags and respective Dockerfile links
* [2.8.1](https://github.com/ncbi/docker/blob/master/blast/2.8.1/Dockerfile)
* [2.8.0](https://github.com/ncbi/docker/blob/master/blast/2.8.0/Dockerfile): [release notes](https://www.ncbi.nlm.nih.gov/books/NBK131777/#_Blast_ReleaseNotes_BLAST_2_8_0_March_28_)
* [2.7.1](https://github.com/ncbi/docker/blob/master/blast/2.7.1/Dockerfile): [release notes](https://www.ncbi.nlm.nih.gov/books/NBK131777/#_Blast_ReleaseNotes_BLAST_2_7_1_October_2_)

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

# License

View refer to the [license](https://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/lxr/source/scripts/projects/blast/LICENSE) and [copyright](http://ncbi.github.io/blast-cloud/dev/copyright.html) information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[docker-bind-mounts]: https://docs.docker.com/storage/bind-mounts/#start-a-container-with-a-bind-mount
[update_blastdb_doc]: https://www.ncbi.nlm.nih.gov/books/NBK537770/
[blast-manual-env-vars]: https://www.ncbi.nlm.nih.gov/books/NBK279695/#_usermanual_Configuring_BLAST_via_environ_
[docker-run-doc]: https://docs.docker.com/engine/reference/run/#general-form
