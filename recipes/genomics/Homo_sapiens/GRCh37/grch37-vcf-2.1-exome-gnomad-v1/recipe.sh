#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

wget --quiet -O - https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.vcf.bgz \
    | bcftools view --threads 3 -O v \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-vcf-2.1-gnomad-v1.vcf.gz

tabix grch37-vcf-2.1-gnomad-v1.vcf.gz
