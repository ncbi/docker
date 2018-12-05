# Official NCBI EDirect docker image

[Entrez Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) command line applications in a Docker image.

## Example usage

### Fetch a nucleotide sequence in FASTA format

  ```bash
  docker run --rm -it ncbi/edirect efetch -db nucleotide -id u00001 -format fasta
  docker run --rm -it ncbi/edirect /bin/sh -c " esearch -db nucleotide -query u00001 | efetch -format fasta"
  ```

### Check installation

  `docker run --rm -it ncbi/edirect installconfirm`

