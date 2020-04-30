#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get autosomes CCRs, sort them, bgzip file, tabix file
wget --quiet -O - https://s3.us-east-2.amazonaws.com/ccrs/ccrs/ccrs.autosomes.v2.20180420.bed.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz

tabix --csi grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz

## Get X chrom CCRs, sort them, bgzip file, tabix file
wget --quiet -O - https://s3.us-east-2.amazonaws.com/ccrs/ccrs/ccrs.xchrom.v2.20180420.bed.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz

tabix --csi grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz

