#!/bin/sh
set -eo pipefail -o nounset

#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" '{ if ( $13 >= 90 ) print $3,$5,$6"\n"$7,$10,$11}' \
    | gsort /dev/stdin $genome \
    | bedtools merge \
    | awk -v OFS="\t" 'BEGIN{ print "#chrom\tstart\tend"}{print $0}' \
    | bgzip -c > hg38-selfchain-90-ucsc-v1.bed.gz

tabix hg38-selfchain-90-ucsc-v1.bed.gz
