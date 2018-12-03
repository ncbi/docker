# blast-workbench

This Docker image contains the latest versions of the following [NCBI](https://www.ncbi.nlm.nih.gov/) software:

* [BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK279690/) command line applications
* [MagicBLAST](https://ncbi.github.io/magicblast/)
* [EDirect](https://dataguide.nlm.nih.gov/edirect/documentation.html)

# How to use this image?

## How to run BLAST?

Please see the [NCBI BLAST Docker image documentation](https://hub.docker.com/r/christiam/blast/).

## How to run EDirect?

  ```bash
  docker run \
    -v $HOME/queries:/blast/queries:rw \
    christiam/blast-workbench \
    sh -c 'esearch -db protein -query NP_002377 | efetch -format fasta > /blast/queries/NP_002377.fsa'
  ```


The [test.sh](./test.sh) script shows some example commands.
