#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Create the remap sed file
##  UCSC <-> Ensembl <->  mapping at: https://github.com/dpryan79/ChromosomeMappings  
##  Any unmapped regions will be dleted 
## Reverse sorted to remove longer contig names before shorter. (Example: chr17_ctg5_hap1 before chr1)
wget --quiet -O - https://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh37_UCSC2ensembl.txt \
    | awk '{if(NF==2) print "s/^"$1"/"$2"/g"; else if(NF==1) print "/^"$1"/d"}' | sort -r > remap.sed

## Get pfam file from UCSC Genes and processes it into a bed file 
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/ucscGenePfam.txt.gz \
    | gzip -dc \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tname\tsocre\tstrand\tthickStart\tthickEnd\treserved\tblockCount\tblockSizes\tchromStarts"} {print $0}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-pfam-domains-ucsc-v1.bed12.bed.gz

## index the bed file using tabix
tabix grch37-pfam-domains-ucsc-v1.bed12.bed.gz

rm remap.sed
