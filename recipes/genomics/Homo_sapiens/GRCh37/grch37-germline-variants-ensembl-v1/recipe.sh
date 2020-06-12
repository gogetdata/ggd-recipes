#!/bin/sh
set -eo pipefail -o nounset



genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get ref genome
ref_genome=$(ggd get-files grch37-reference-genome-ensembl-v1 --pattern "*.fa" )
fai_file=$(ggd get-files grch37-reference-genome-ensembl-v1 --pattern "*.fai" )

wget --quiet ftp://ftp.ensembl.org/pub/release-75/variation/vcf/homo_sapiens/Homo_sapiens_incl_consequences.vcf.gz 

## Add contig header
## Decompose 
## Normalize
bcftools reheader --fai $fai_file Homo_sapiens_incl_consequences.vcf.gz \
    | gzip -dc \
    | vt decompose -s - \
    | vt normalize -r $ref_genome -n - -o grch37-decomposed-normalized-germline.vcf 

rm Homo_sapiens_incl_consequences.vcf.gz

## Sort 
## bgzip 
## Tabix
gsort grch37-decomposed-normalized-germline.vcf $genome \
    | bgzip -c > grch37-germline-variants-ensembl-v1.vcf.gz

tabix grch37-germline-variants-ensembl-v1.vcf.gz

rm grch37-decomposed-normalized-germline.vcf
