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





2. Run an instance of the image, mounting in directories with the required sequences/databases/files and setting the working directory as appropriate. If no program is specified, the default behaviour is to drop you into a shell in your working directory.

            `docker run --rm -v /home/simonalpha/project:/blast -v /databases:/db -w /blast simonalpha/ncbi-blast-docker`

               All the BLAST binaries in the default distribution are available and on the path, and you can run BLAST as usual.

                  Another option is to provide a BLAST invocation when starting a container; much more useful for scripting! Ensure your BLAST invocation uses the paths you are mounting to in the container.

                     `docker run --rm -v /home/simonalpha/project:/blast -v /databases:/db -w /blast simonalpha/ncbi-blast-docker blastp -query /blast/q_seq.faa -db /db/prot_db -out q_seq_V_prot_db`

                     The above is based strongly on how Galaxy uses Docker containers, however other methods are definitely possible. If you come across any, please do let us know.

                     I recommend use of `--rm` in your run commands, it automatically clears the containers after use. However, this requires you write your data into a mounted path, otherwise your results will be deleted with the container.

                     ## Users and Permissions
                     These images currently run as root, to allow easy read-write access to mounted volumes. This will change in the future with enabling patches in Galaxy, based around UIDs rather than users.

                     ## Repository Structure
                     The layout of this repository is based on the structure of the [Java Dockerfile](https://github.com/dockerfile/java) repository for clear separation of versions and easy setup of automated builds. Suggestions or Pull Requests for better organisation most welcome.
