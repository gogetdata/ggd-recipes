#!/bin/sh
set -eo pipefail -o nounset

## Genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## chrom mapping
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Get fai file
fai_file=$(ggd get-files hg19-reference-genome-ucsc-v1 --pattern "*.fai")

## Get the  vcf file, filter it, and create compress to bcf 
wget --quiet -O gnomad.exomes.r2.1.1.sites.vcf.gz https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.vcf.bgz \


bcftools reheader --fai $fai_file --threads 3 gnomad.exomes.r2.1.1.sites.vcf.gz \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | bcftools view -O b --no-version --threads 3 -o hg19-exome-variants-gnomad-v1.bcf  

bcftools index --threads 3 --csi hg19-exome-variants-gnomad-v1.bcf

rm gnomad.exomes.r2.1.1.sites.vcf.gz

