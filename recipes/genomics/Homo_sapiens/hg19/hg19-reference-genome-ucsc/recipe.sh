#!/bin/sh
set -eo pipefail -o nounset
## Get the latest hg19 reference genome for USCS. (Patch 13) 
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/hg19Patch13/hg19Patch13.fa.gz

## Unzip file using gzip
gzip -fd hg19Patch13.fa.gz

## Index the fasta file using samtools 
samtools faidx hg19Patch13.fa


