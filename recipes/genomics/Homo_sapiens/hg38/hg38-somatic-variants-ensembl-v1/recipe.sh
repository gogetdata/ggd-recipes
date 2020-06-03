#!/bin/sh
set -eo pipefail -o nounset

## Get the .genome  file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Get ref genome
ref_genome=$(ggd get-files grch38-reference-genome-ensembl-v1 --pattern "*.fa" )
fai_file=$(ggd get-files grch38-reference-genome-ensembl-v1 --pattern "*.fai" )

## Get the somatic variant file, sort it, bgzip it, and tabix it
wget --quiet ftp://ftp.ensembl.org/pub/release-99/variation/vcf/homo_sapiens/homo_sapiens_somatic_incl_consequences.vcf.gz 

## Add contig header
## Decompose 
## Normalize
bcftools reheader --fai $fai_file homo_sapiens_somatic_incl_consequences.vcf.gz \
    | gzip -dc \
    | vt decompose -s - \
    | vt normalize -r $ref_genome -n - -o grch38-decomposed-normalized-somatic.vcf 

rm homo_sapiens_somatic_incl_consequences.vcf.gz

## Update contig header
fai_file=$(ggd get-files hg38-reference-genome-ucsc-v1 --pattern "*.fai" )
bcftools reheader --fai $fai_file grch38-decomposed-normalized-somatic.vcf > hg38-decomposed-normalized-somatic.vcf

rm grch38-decomposed-normalized-somatic.vcf


## Sort 
## bgzip 
## Tabix
gsort --chromosomemappings $chrom_mapping hg38-decomposed-normalized-somatic.vcf $genome \
    | bgzip -c > hg38-somatic-variants-ensembl-v1.vcf.gz

tabix hg38-somatic-variants-ensembl-v1.vcf.gz

rm hg38-decomposed-normalized-somatic.vcf



