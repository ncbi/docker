#!/bin/bash
set -ex

mkdir -p binaries
cd binaries
wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/demo/vecscreen
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/VSlistTo1HitPerLine.awk

mkdir -p ../databases
cd ../databases
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/contam_in_euks.fa.gz
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/contam_in_prok.fa
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/adaptors_for_screening_euks.fa
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/adaptors_for_screening_proks.fa
wget -nc ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/mito.nt.gz
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/kitts/rrna.gz
wget -nc ftp://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec
cd ..

USERNAME=ncbi
IMAGE=contamfilter
VERSION=`cat VERSION`

docker build -t $USERNAME/$IMAGE:$VERSION .
docker tag $USERNAME/$IMAGE:$VERSION $USERNAME/$IMAGE:latest


