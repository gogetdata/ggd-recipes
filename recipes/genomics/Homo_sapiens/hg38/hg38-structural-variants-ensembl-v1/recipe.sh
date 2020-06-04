#!/bin/sh
set -eo pipefail -o nounset

## Get the .genome  file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Get the structural variant file, sort it, bgzip it, tabix it
wget --quiet ftp://ftp.ensembl.org/pub/release-99/variation/vcf/homo_sapiens/homo_sapiens_structural_variations.vcf.gz

## Get the reference genome 
fai_file=$(ggd get-files hg38-reference-genome-ucsc-v1 --pattern "*.fai")
bcftools reheader --fai $fai_file homo_sapiens_structural_variations.vcf.gz  > homo_sapiens_structural_variations.vcf 

gsort --chromosomemappings $chrom_mapping homo_sapiens_structural_variations.vcf $genome \
    | bgzip -c > hg38-structural-variants-ensembl-v1.vcf.gz

tabix hg38-structural-variants-ensembl-v1.vcf.gz

rm homo_sapiens_structural_variations.vcf
rm homo_sapiens_structural_variations.vcf.gz

