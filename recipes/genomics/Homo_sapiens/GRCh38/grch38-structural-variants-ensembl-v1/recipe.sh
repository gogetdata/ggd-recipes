#!/bin/sh
set -eo pipefail -o nounset

## Get the .genome  file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the structural variant file, sort it, bgzip it, tabix it
wget --quiet ftp://ftp.ensembl.org/pub/release-99/variation/vcf/homo_sapiens/homo_sapiens_structural_variations.vcf.gz

## Get the reference genome 
fai_file=$(ggd get-files grch38-reference-genome-ensembl-v1 --pattern "*.fai")
bcftools reheader --fai $fai_file homo_sapiens_structural_variations.vcf.gz  > homo_sapiens_structural_variations.vcf 

gsort homo_sapiens_structural_variations.vcf $genome \
    | bgzip -c > grch38-structural-variants-ensembl-v1.vcf.gz

tabix grch38-structural-variants-ensembl-v1.vcf.gz

rm homo_sapiens_structural_variations.vcf.gz
rm homo_sapiens_structural_variations.vcf
