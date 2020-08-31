#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ensembl.org/pub/release-100/gtf/homo_sapiens/Homo_sapiens.GRCh38.100.gtf.gz 

cat <(zgrep "^#" Homo_sapiens.GRCh38.100.gtf.gz) <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(zgrep -E "five_prime_utr|three_prime_utr" Homo_sapiens.GRCh38.100.gtf.gz) \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-utr-only-features-ensembl-v1.gtf.gz

tabix grch38-utr-only-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.100.gtf.gz
