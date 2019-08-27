# NCBI MagicBLAST docker image

[NCBI MagicBLAST][1] command line application in a Docker image.

# Usage instructions

You may run the MagicBLAST docker image in a few different ways.  The simplest is the interactive mode, which simply executes a command and exits, and this is ideal if MagicBLAST is executed only once.  Running in detached mode is a two step process.  First, you start the MagicBLAST docker image, giving it a name and specifying the directories containing your queries, databases etc. and how they map to the directory structure inside the docker image.  Second, you execute your command specifying the name of your detached image.  Examples are below.

### Interactive command:

  `docker run --rm -it -v $BLASTDB:/blast/blastdb ncbi/magicblast magicblast -version`

### Starting Detached mode:

   ``` bash
   docker run --rm -d --name mblast \
      -v $BLASTDB:/blast/blastdb:ro -v $HOME/blastdb_custom:/blast/blastdb_custom:ro \
      -v $HOME/queries:/blast/queries:ro \
      -v $HOME/results:/blast/results:rw \
      ncbi/magicblast sleep infinity
   ```
    
### Check that it is running:
   ``` bash
      docker ps
   ```
   
### Running search with detached docker:

   ``` bash
    docker exec mblast magicblast -db GCF_000001405.38_top_level \
        -sra DRR138536 -out /blast/results/DRR138536.tab -num_threads 8
   ```
    
The above command will align the reads in https://www.ncbi.nlm.nih.gov/sra/DRR138536 to GCF_000001405.38_top_level (human genome) using eight threads.  This command assumes that the human database has been downloaded to $BLASTDB, or that remote fuser will perform the download for you, and that a detached image with the name "mblast" has been started.  This also assumes that your machine has the directory structure suggested at https://github.com/ncbi/docker/blob/master/blast/README.md  
    
Please note that this docker image contains only the magicblast executable.  The blast-workbench container (see https://github.com/ncbi/docker/blob/master/blast-workbench/README.md) hosts magicblast as well as utilities to update databases, fetch lists of taxids or make BLAST databases.  

The magicBLAST documentaton is at https://ncbi.github.io/magicblast/

[1]: https://www.ncbi.nlm.nih.gov/pubmed/31345161
