# Official NCBI EDirect docker image

[Entrez Direct][1] command line applications in a Docker image.

## Example usage

### Fetch a nucleotide sequence in FASTA format

  `docker run --rm -it christiam/edirect /bin/sh -c " esearch -db nucleotide -query u00001 | efetch -format fasta"`

### Check installation

  `docker run --rm -it christiam/edirect installconfirm`

[1]: https://www.ncbi.nlm.nih.gov/books/NBK179288/
