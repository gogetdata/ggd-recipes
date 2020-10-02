#!/bin/sh
set -eo pipefail -o nounset

## Get genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get mapping file
chr_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get fai file
fai_file=$(ggd get-files grch38-reference-genome-gencode-v1 --pattern "*.fai")

## Get the  vcf file, filter it, and create compress to bcf 
wget --quiet -O gnomad.exomes.r2.1.1.sites.liftover_grch38.vcf.gz https://storage.googleapis.com/gnomad-public/release/2.1.1/liftover_grch38/vcf/exomes/gnomad.exomes.r2.1.1.sites.liftover_grch38.vcf.bgz \

bcftools reheader --fai $fai_file --threads 3 gnomad.exomes.r2.1.1.sites.liftover_grch38.vcf.gz \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | bcftools view -O b --no-version --threads 3 -o grch38-exome-variants-gnomad-v1.bcf  

bcftools index --threads 3 --csi grch38-exome-variants-gnomad-v1.bcf

rm gnomad.exomes.r2.1.1.sites.liftover_grch38.vcf.gz
