# ncbi-workbench

This (experimental) Docker image contains the latest versions of the following [NCBI][1] software:

* [BLAST+][blast_man] command line applications
* [MagicBLAST][mb_doc]
* [EDirect][edir_doc]
* [SRA Toolkit][srat_doc]

# How to use this image?

## How to run BLAST?

Please see the [NCBI BLAST+ Docker image documentation][blast_docker] and replace `ncbi/blast` with
`ncbi/workbench`.

## How to run EDirect?

  ```bash
  docker run --rm \
    -v $HOME/queries:/blast/queries:rw \
    ncbi/workbench \
    sh -c 'efetch -db protein -id NP_002377 -format fasta > /blast/queries/NP_002377.fsa'
  ```

You can verify the results of this command on the local host as follows:

  `ls -l $HOME/queries`

The [test.sh](./test.sh) script shows some additional sample commands.

## How to run SRA toolkit tools?

  ```bash
  docker run --rm \
  
  ```

Credit: https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump

## Maintainer's notes

A `Makefile` is provided to conveniently maintain this docker image. It 
contains the variables `USERNAME` and `VERSION` which can be configured
at runtime to faciliate maintenance, e.g.:

* `make build VERSION=0.2`: builds the docker image and tags it with version `0.2` and `latest`
* `make publish USERNAME=ronaldo`: publishes the image to Docker Hub under the name `ronaldo/workbench`
* `make check`: performs a sanity check on the most recently built image using default values (e.g.: `ncbi/workbench`


[1]: https://www.ncbi.nlm.nih.gov
[blast_man]: https://www.ncbi.nlm.nih.gov/books/NBK279690/
[mb_doc]: https://ncbi.github.io/magicblast/
[edir_doc]: https://dataguide.nlm.nih.gov/edirect/documentation.html
[srat_doc]: https://github.com/ncbi/sra-tools/wiki
[blast_docker]: https://github.com/ncbi/docker/blob/master/blast/README.md

