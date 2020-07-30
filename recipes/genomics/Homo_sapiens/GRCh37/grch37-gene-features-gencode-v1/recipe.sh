#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.annotation.gtf.gz

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

cat <(gzip -dc gencode.v34lift37.annotation.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc gencode.v34lift37.annotation.gtf.gz | grep -v "^#") \
    | gsort --chromosomemappings  $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-gene-features-gencode-v1.gtf.gz

tabix grch37-gene-features-gencode-v1.gtf.gz

rm gencode.v34lift37.annotation.gtf.gz
