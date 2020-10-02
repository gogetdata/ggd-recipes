#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Get the  vcf file, filter it, and create compress to bcf 
wget --quiet -O - https://storage.googleapis.com/gnomad-public/release/2.1.1/liftover_grch38/vcf/exomes/gnomad.exomes.r2.1.1.sites.liftover_grch38.vcf.bgz \
    | bcftools view --no-version --threads 3 -O v \
    | gsort /dev/stdin $genome \
    | bcftools view -O b --no-version --threads 3 -o hg38-exome-variants-gnomad-v1.bcf  

bcftools index --threads 3 --csi hg38-exome-variants-gnomad-v1.bcf
