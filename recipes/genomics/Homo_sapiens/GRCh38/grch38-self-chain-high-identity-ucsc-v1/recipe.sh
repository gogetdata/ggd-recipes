#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
awk '{if (NR > 1) print $1,$2} ' $chrom_mapping \
    | sort -k2,2n -r \
    | awk '{print "s/"$1"/"$2"/g"}' > remap.sed

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" '{ if ( $13 >= 90 ) print $3,$5,$6"\n"$7,$10,$11}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bedtools merge \
    | awk -v OFS="\t" 'BEGIN{ print "#chrom\tstart\tend"}{print $0}' \
    | bgzip -c > grch38-selfchain-90-ucsc-v1.bed.gz

tabix grch38-selfchain-90-ucsc-v1.bed.gz

rm remap.sed


