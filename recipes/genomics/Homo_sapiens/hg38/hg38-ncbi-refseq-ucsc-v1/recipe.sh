#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/ncbiRefSeq.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tstrand\tcdsStart\tcdsEnd\tname\tname2\texonCount\texonStarts\texonEnds\texonFrames"} {print $3, $5, $6, $4, $7, $8, $2, $13, $9, $10, $11, $16}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-ncbi-refseq-ucsc-v1.bed.gz

tabix hg38-ncbi-refseq-ucsc-v1.bed.gz
