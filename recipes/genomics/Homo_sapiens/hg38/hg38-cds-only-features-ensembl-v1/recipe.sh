#!/bin/sh
set -eo pipefail -o nounset


## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Process GTF file
wget --quiet ftp://ftp.ensembl.org/pub/release-100/gtf/homo_sapiens/Homo_sapiens.GRCh38.100.gtf.gz 

cat <(gzip -dc Homo_sapiens.GRCh38.100.gtf.gz | grep "^#") <(gzip -dc Homo_sapiens.GRCh38.100.gtf.gz | grep -v "^#") \
    | awk -v OFS="\t" 'BEGIN{print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} { if ( $3 == "CDS") print $0}' \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | bgzip -c > hg38-cds-only-features-ensembl-v1.gtf.gz

tabix hg38-cds-only-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.100.gtf.gz
