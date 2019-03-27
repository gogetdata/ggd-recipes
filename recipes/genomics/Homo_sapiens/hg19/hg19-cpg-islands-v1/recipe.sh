#!/bin/sh
set -eo pipefail -o nounset

## Get the hg19.genome file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## Get the hg19 cpg island file and process it  
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | cut -f 2-5 \
    | gsort /dev/stdin $genome \
    | bgzip -c > cpg.bed.gz

## Tabix the processesed cpg file
tabix cpg.bed.gz
