#!/bin/sh
set -eo pipefail -o nounset



## Get the danRer10 reference genome from UCSC
wget --quiet -O danrer10-reference-genome-ucsc-v1.fa.gz  ftp://hgdownload.soe.ucsc.edu/goldenPath/danRer10/bigZips/danRer10.fa.gz 

## Unzip fhte file using GNU zip
gzip -fd danrer10-reference-genome-ucsc-v1.fa.gz

## Index the reference genome
samtools faidx danrer10-reference-genome-ucsc-v1.fa  

