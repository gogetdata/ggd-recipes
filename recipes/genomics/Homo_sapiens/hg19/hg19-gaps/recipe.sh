#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > gaps.bed.gz

tabix gaps.bed.gz

