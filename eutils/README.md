# Official NCBI EDirect docker image

[Entrez Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) command line applications in a Docker image.

## Example usage

### Fetch a nucleotide sequence in FASTA format

  `docker run --rm -it christiam/edirect /bin/sh -c " esearch -db nucleotide -query u00001 | efetch -format fasta"`

### Check installation

  `docker run --rm -it christiam/edirect installconfirm`

