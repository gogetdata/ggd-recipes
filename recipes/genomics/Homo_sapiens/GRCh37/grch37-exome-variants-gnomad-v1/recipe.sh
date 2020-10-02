#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the  vcf file, filter it, and create compress to bcf 
wget --quiet -O - https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.vcf.bgz \
    | bcftools view --no-version --threads 3 -O v \
    | gsort /dev/stdin $genome \
    | bcftools view -O b --no-version --threads 3 -o grch37-exome-variants-gnomad-v1.bcf  

bcftools index --threads 3 --csi grch37-exome-variants-gnomad-v1.bcf
