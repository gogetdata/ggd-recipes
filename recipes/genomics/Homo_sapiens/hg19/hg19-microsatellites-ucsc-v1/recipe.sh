#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/microsat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\ttype"} {print $2,$3,$4,$5}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-microsat-ucsc-v1.bed.gz
tabix hg19-microsat-ucsc-v1.bed.gz