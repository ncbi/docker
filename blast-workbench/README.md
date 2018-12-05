# blast-workbench

This Docker image contains the latest versions of the following [NCBI][1] software:

* [BLAST+][blast_man] command line applications
* [MagicBLAST][mb_doc]
* [EDirect][edir_doc]

# How to use this image?

## How to run BLAST?

Please see the [NCBI BLAST+ Docker image documentation][blast_docker].

## How to run EDirect?

  ```bash
  docker run --rm \
    -v $HOME/queries:/blast/queries:rw \
    ncbi/blast-workbench \
    efetch -db protein -id NP_002377 format fasta > /blast/queries/NP_002377.fsa'
  ```

You can verify the results of this command on the local host as follows:

  `ls -l $HOME/queries`


The [test.sh](./test.sh) script shows some example commands.

[1]: https://www.ncbi.nlm.nih.gov
[blast_man]: https://www.ncbi.nlm.nih.gov/books/NBK279690/
[mb_doc]: https://ncbi.github.io/magicblast/
[edir_doc]: https://dataguide.nlm.nih.gov/edirect/documentation.html
[blast_docker]: https://github.com/ncbi/docker/blob/master/blast/README.md
