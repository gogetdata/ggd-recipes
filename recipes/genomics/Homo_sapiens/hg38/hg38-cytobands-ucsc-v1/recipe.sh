#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

# download, header, sort, bgzip
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cytoBand.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tband\tstain"} {print $1,$2,$3,$4,$5}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-cytoband-ucsc-v1.bed.gz

# index the bed file using tabix
tabix hg38-cytoband-ucsc-v1.bed.gz