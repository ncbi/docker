# Official NCBI EDirect docker image

[Entrez Direct][1] command line applications in a Docker image.

# Usage instructions

  `docker run --rm -it christiam/edirect installconfirm`

  `docker run --rm -it christiam/edirect esearch -db nucleotide -query u00001 | efetch -format fasta`


[1]: https://www.ncbi.nlm.nih.gov/books/NBK179288/
