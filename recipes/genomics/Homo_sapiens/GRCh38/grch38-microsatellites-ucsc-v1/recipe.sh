#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/microsat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=microsat&hgta_table=microsat&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\ttype"} {print $2,$3,$4,$5}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-microsat-ucsc-v1.bed.gz

# index the bed file using tabix
tabix grch38-microsat-ucsc-v1.bed.gz

