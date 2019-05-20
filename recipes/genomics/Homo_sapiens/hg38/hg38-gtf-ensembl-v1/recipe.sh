#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Create the remap sed file
##  UCSC <-> Ensembl mapping at: https://github.com/dpryan79/ChromosomeMappings  
##  Any unmapped regions will be dleted 
wget --quiet -O - https://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh38_ensembl2UCSC.txt \
    | awk '{if(NF==2) print "s/^"$1"/"$2"/g"; else if(NF==1) print "/^"$1"/d"}' > remap.sed

## Get Ensembl gtf file
wget --quiet -O - ftp://ftp.ensembl.org/pub/release-96/gtf/homo_sapiens/Homo_sapiens.GRCh38.96.gtf.gz \
    | gzip -dc \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-gtf-ensembl-v1.gtf.gz

tabix hg38-gtf-ensembl-v1.gtf.gz

rm remap.sed
