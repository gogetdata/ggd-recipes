#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Create the remap sed file
##  UCSC <-> Ensembl <->  mapping at: https://github.com/dpryan79/ChromosomeMappings  
##  Any unmapped regions will be dleted 
wget --quiet -O - https://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh37_UCSC2ensembl.txt \
    | awk '{if(NF==2) print "s/^"$1"/"$2"/g"; else if(NF==1) print "/^"$1"/d"}' | sort -r > remap.sed

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/microsat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\ttype"} {print $2,$3,$4,$5}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-microsat-ucsc-v1.bed.gz

# index the bed file using tabix
tabix grch37-microsat-ucsc-v1.bed.gz

# cleanup
rm remap.sed