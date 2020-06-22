#!/bin/sh
set -eo pipefail -o nounset

## Get the genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/evofold.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=evofold&hgta_table=evofold&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tUCSC_event_name\tsize\tscore\tstrand\tmRNAsecstruct\tsecondary_struct_conf"} {print $2,$3,$4,$5,$8,$6,$7,$9,$10}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-evofold-ucsc-v1.bed.gz

tabix grch37-evofold-ucsc-v1.bed.gz
