#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/simpleRepeat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsequence\tscore\tstrand\tperiod\tcopy_num"} {print $2,$3,$4,$17,$12,"+",$6,$7}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-simplerepeats-ucsc_v1.bed.gz

tabix hg38-simplerepeats-ucsc_v1.bed.gz
