#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/evofold.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\tscore\tstrand\tmRNAsecstruct\tsecondary_struct_conf"} {print $2,$3,$4,$8,$6,$7,$9,$10}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-evofold-ucsc-v1.bed.gz

tabix hg19-evofold-ucsc-v1.bed.gz
