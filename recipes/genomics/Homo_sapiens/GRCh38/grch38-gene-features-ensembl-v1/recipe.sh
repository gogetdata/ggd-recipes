#!/bin/sh
set -eo pipefail -o nounset


## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ensembl.org/pub/release-99/gtf/homo_sapiens/Homo_sapiens.GRCh38.99.gtf.gz 

cat <(gzip -dc Homo_sapiens.GRCh38.99.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc Homo_sapiens.GRCh38.99.gtf.gz | grep -v "^#") \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-gene-features-ensembl-v1.gtf.gz

tabix grch38-gene-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.99.gtf.gz
