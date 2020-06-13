#!/bin/sh
set -eo pipefail -o nounset

## Get the latest hg19 reference genome for USCS. (Patch 13) 
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/p13.plusMT/hg19.p13.plusMT.fa.gz \
    | gzip -dc \
    | bgzip -c > hg19-reference-genome-ucsc-v1.fa.gz 

## Index the fasta file using samtools 
samtools faidx hg19-reference-genome-ucsc-v1.fa.gz
