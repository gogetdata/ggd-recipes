#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz

## Chrom mapping
chr_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

awk -v OFS="\t" '{ if (NF == 2) print $0}' $chr_mapping > chrom_mapping.txt

awk -v OFS="\t" '{ if (NF == 1) print $0}' $chr_mapping > skip.txt

## Process, sort, and bgzip gtf 
cat <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep "^#") <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep -v -f skip.txt |  grep -v "^#") \
    | awk -v OFS="\t" 'BEGIN{print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} { if ( $3 == "gene") print $0}' \
    | gsort --chromosomemappings chrom_mapping.txt /dev/stdin $genome \
    | bgzip -c > hg38-gene-only-features-gencode-v1.gtf.gz

tabix hg38-gene-only-features-gencode-v1.gtf.gz

## remove extra files
rm gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz
rm skip.txt
rm chrom_mapping.txt
