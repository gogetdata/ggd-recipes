#!/bin/sh
set -eo pipefail -o nounset


## Get the .genome  file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get ref genome
ref_genome=$(ggd get-files grch38-reference-genome-ensembl-v1 --pattern "*.fa" )
fai_file=$(ggd get-files grch38-reference-genome-ensembl-v1 --pattern "*.fai" )

## Get the phenotype assocaited variant file, sort it, bgzip it, tabix it
wget --quiet ftp://ftp.ensembl.org/pub/release-99/variation/vcf/homo_sapiens/homo_sapiens_phenotype_associated.vcf.gz 

## Add contig header
## Decompose 
## Normalize
bcftools reheader --fai $fai_file homo_sapiens_phenotype_associated.vcf.gz \
    | gzip -dc \
    | vt decompose -s - \
    | vt normalize -r $ref_genome -n - -o grch38-decomposed-normalized-phenotype-associated.vcf 

rm homo_sapiens_phenotype_associated.vcf.gz

## Sort 
## bgzip 
## Tabix
gsort grch38-decomposed-normalized-phenotype-associated.vcf $genome \
    | bgzip -c > grch38-phenotype-associated-variants-ensembl-v1.vcf.gz

tabix grch38-phenotype-associated-variants-ensembl-v1.vcf.gz

rm grch38-decomposed-normalized-phenotype-associated.vcf

