#!/bin/sh
set -eo pipefail -o nounset


## get the .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the missense z score from the gnomad donwload site
wget --quiet -O - https://storage.googleapis.com/gnomad-public/legacy/exac_browser/forweb_cleaned_exac_r03_march16_z_data_pLI_CNV-final.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\ttxStart\ttxEnd\tgene_symbol\ttranscript_id\texon_number\tnbps\tmissense_z_score"} 
                             { if (NR > 1) print $3,$5,$6,$2,$1,$4,$7,$18}' \
    | gsort /dev/stdin $genome \
    | uniq \
    | bgzip -c > grch37-missense-z-exac-v1.bed.gz

tabix grch37-missense-z-exac-v1.bed.gz

