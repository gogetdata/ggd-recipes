#!/bin/sh
set -eo pipefail -o nounset
## Get the latest hg38 reference genome for USCS. (Patch 12) 
wget --quiet -O hg38-reference-genome-ucsc-v1.fa.gz  http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/p12/hg38.p12.fa.gz

## Unzip file using gzip
gzip -fd hg38-reference-genome-ucsc-v1.fa.gz

## Index the fasta file using samtools 
samtools faidx hg38-reference-genome-ucsc-v1.fa.gz
