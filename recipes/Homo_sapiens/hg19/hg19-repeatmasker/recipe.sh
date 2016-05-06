#!/bin/bash
set -e o pipefail -o nounset
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
wget -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/rmsk.txt.gz \
    | gzip -dc \
    | cut -f 2-5 \
    | gsort /dev/stdin $genome \
    | bgzip -c > rmsk.bed.gz

tabix rmsk.bed.gz
