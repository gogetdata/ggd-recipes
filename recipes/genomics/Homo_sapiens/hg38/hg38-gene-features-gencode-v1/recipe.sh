#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
wget --quiet $genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
wget --quiet $genome2

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz

## Chrom mapping
chr_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## If no chrom mapping, use existing patch/scaffolding name
gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz \
    | grep -v "^#" \
    | awk -v OFS="\t" '{ if ( ! ($1 ~ /^chr/ ) ) print $1}' \
    | uniq \
    | grep -f - GRCh38.genome >> hg38.genome

awk -v OFS="\t" '{ if (NF == 2) print $0}' $chr_mapping > chrom_mapping.txt

## Process, sort, and bgzip gtf 
cat <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep -v "^#") \
    | gsort --chromosomemappings chrom_mapping.txt /dev/stdin hg38.genome \
    | bgzip -c > hg38-gene-features-gencode-v1.gtf.gz

tabix hg38-gene-features-gencode-v1.gtf.gz

## remove extra files
rm gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz
rm hg38.genome
rm GRCh38.genome
rm chrom_mapping.txt
