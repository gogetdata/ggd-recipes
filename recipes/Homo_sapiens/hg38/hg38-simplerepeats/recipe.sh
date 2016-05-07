#!/bin/bash
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg38/hg38.genome
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38	/database/simpleRepeat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsequence\tscore\tstrand\tperiod\tcopy_num"} {print $2,$3,$4,$17,$12,"+",$6,$7}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > simplerepeats.hg38.bed.gz

tabix simplerepeats.hg38.bed.gz
