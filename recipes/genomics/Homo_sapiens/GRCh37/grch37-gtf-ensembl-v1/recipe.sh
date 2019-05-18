#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

wget --quiet -O - ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-gtf-ensembl-v1.gtf.gz

tabix grch37-gtf-ensembl-v1.gtf.gz
