#!/bin/sh
set -eo pipefail -o nounset


## get the .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Get the pLI score from the gnomad donwload site
wget --quiet -O - https://storage.googleapis.com/gnomad-public/legacy/exac_browser/forweb_cleaned_exac_r03_march16_z_data_pLI_CNV-final.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\ttxStart\ttxEnd\tgene_symbol\ttranscript_id\texon_number\tn_bp\tpLI"} 
                             { if (NR > 1) print $3,$5,$6,$2,$1,$4,$7,$20}' \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | uniq \
    | bgzip -c > hg19-pli-scores-exac-v1.bed.gz

tabix hg19-pli-scores-exac-v1.bed.gz

