#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

wget --quiet -O - ftp://ftp.ensembl.org/pub/release-96/gtf/homo_sapiens/Homo_sapiens.GRCh38.96.gtf.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-gtf-ensembl-v1.gtf.gz

tabix grch38-gtf-ensembl-v1.gtf.gz
