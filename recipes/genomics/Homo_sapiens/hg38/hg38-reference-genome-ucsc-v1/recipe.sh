#!/bin/sh
set -eo pipefail -o nounset

## Get the latest hg19 reference genome for USCS. (Patch 13) 
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/p12/hg38.p12.fa.gz \
    | gzip -dc \
    | bgzip -c > hg38-reference-genome-ucsc-v1.fa.gz 

## Index the fasta file using samtools 
samtools faidx hg38-reference-genome-ucsc-v1.fa.gz
