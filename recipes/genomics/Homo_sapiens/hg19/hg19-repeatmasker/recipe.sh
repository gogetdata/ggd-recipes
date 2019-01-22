#!/bin/sh
set -eo pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/rmsk.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tfamily_class_name\tdiv+del+ins\tstrand"} {print $6,$7,$8,$12"_"$13"_"$11,$3+$4+$5,$10}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > rmsk.bed.gz

tabix rmsk.bed.gz

