#!/bin/sh
set -eo pipefail -o nounset



genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

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

fai_file=$(ggd get-files hg19-reference-genome-ucsc-v1 --pattern "*.fai" )

## Sort 
## bgzip 
## Tabix
bcftools reheader --fai $fai_file grch37-decomposed-normalized-germline.vcf \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome \
    | bgzip -c > hg19-germline-variants-ensembl-v1.vcf.gz

tabix hg19-germline-variants-ensembl-v1.vcf.gz

rm grch37-decomposed-normalized-germline.vcf

