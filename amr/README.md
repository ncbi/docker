Docker image creation for NCBI's AMRFinderPlus
================================================

The [AMRFinderPlus](https://github.com/ncbi/amr/wiki) software and the accompanying database are designed to find acquired antimicrobial resistance genes and point mutations in protein and/or assembled nucleotide sequences. We have also added "plus" stress, heat, and biocide resistance and virulence factors for [some organisms](https://github.com/evolarjun/amr/wiki/Curated-organisms).

See [the AMRFinderPlus wiki](https://github.com/ncbi/amr/wiki) for documentation of the software and database.

Note that this image contains both software and database.

Building 
---------
To build the image use the script `build-image.sh` which will grab the latest versions of software and database from the internet to facilitate tagging of the resulting image.

Usage
---------

### Run core only on a file with 8 threads
```
docker run --rm -v ${PWD}:/data ncbi/amr \
    amrfinder -p test_prot.fa --threads 8 > amrfinder.out
```

### Update the database then run AMRFinderPlus

Note that this image contains both software and database. It is updated with
every software and database release, so if your docker image is up-to-date then
you shouldn't need to update the database to get the latest results.

```
docker run --rm -v ${PWD}:/data ncbi/amr \
   bash -c 'amrfinder -u && amrfinder -p test_prot.fa --threads 8' \
   > amrfinder.out
```

See [Running AMRFinderPlus](https://github.com/ncbi/amr/wiki/Running-AMRFinderPlus) for details on AMRFinderPlus command-line options.

