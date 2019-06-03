#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Create the remap sed file
##  UCSC <-> Ensembl <->  mapping at: https://github.com/dpryan79/ChromosomeMappings  
##  Any unmapped regions will be dleted 
wget --quiet -O - https://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh37_UCSC2ensembl.txt \
    | awk '{if(NF==2) print "s/^"$1"/"$2"/g"; else if(NF==1) print "/^"$1"/d"}' > remap.sed

## Get hg19 evofold file
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/evofold.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\tscore\tstrand\tmRNAsecstruct\tsecstrcut_conf"} {print $2,$3,$4,$8,$6,$7,$9,$10}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-evofold-ucsc-v1.bed.gz

tabix grch37-evofold-ucsc-v1.bed.gz

rm remap.sed
