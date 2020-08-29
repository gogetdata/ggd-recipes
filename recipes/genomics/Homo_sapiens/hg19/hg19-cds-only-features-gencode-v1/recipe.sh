#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.annotation.gtf.gz

cat <(gzip -dc gencode.v34lift37.annotation.gtf.gz | grep "^#") <(gzip -dc gencode.v34lift37.annotation.gtf.gz | grep -v "^#") \
    | awk -v OFS="\t" 'BEGIN{print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} { if ( $3 == "CDS") print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-cds-features-gencode-v1.gtf.gz

tabix hg19-cds-features-gencode-v1.gtf.gz

rm gencode.v34lift37.annotation.gtf.gz
