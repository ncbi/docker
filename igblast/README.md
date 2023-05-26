# NCBI IgBLAST docker image

[NCBI IgBLAST][1] command line application in a Docker image.

# Running IgBLAST

IgBLAST image can be run following standard docker methods.  Some examples are shown below (assuming your image version is 1.21.0 and work directory 
has a folder named "database" that has the germline gene databases you want to search and a folder named "query" that has your query sequence file).  

1. To run interactively, issue the command:
```
docker run -e IGDATA=/ncbi-igblast-1.21.0  -v $HOME/database:/d -v $HOME/query:/q -it ncbi/igblast
```
You will get a docker terminal like this:
```
root@27af8892c20b:/# 
```

To run igblastn, simply issue:
```
igblastn -query /q/temp.query -germline_db_V /d/human_gl_V -germline_db_D /d/human_gl_D -germline_db_J /d/human_gl_J -show_translation -auxiliary_data optional_file/human_gl.aux -organism human
```

2.  You can also run the image directly as follows:
```
docker run -e IGDATA=/ncbi-igblast-1.21.0 -v $HOME/database:/d -v $HOME/query:/q ncbi/igblast igblastn -query /q/temp.query -germline_db_V /d/human_gl_V -germline_db_D /d/human_gl_D -germline_db_J /d/human_gl_J -show_translation -auxiliary_data optional_file/human_gl.aux -organism human
```
 
Note that this image contains only IgBLAST executable for Linux platform.  The IgBLAST documentation is at https://ncbi.github.io/igblast/

[1]: https://pubmed.ncbi.nlm.nih.gov/23671333/
