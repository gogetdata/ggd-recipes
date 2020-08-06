#!/bin/sh
set -eo pipefail -o nounset

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz

gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz \
    | grep -v "^#" \
    | awk -v OFS="\t" 'BEGIN {print "chrM\tMT"} { if ( $1 != "chrM") gsub("chr","", $1); print "chr"$1, $1}' \
    | uniq >  chrom_mapping.txt

cat <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep -v "^#") \
    | gsort --chromosomemappings chrom_mapping.txt /dev/stdin $genome \
    | bgzip -c > grch38-gene-features-gencode-v1.gtf.gz

tabix grch38-gene-features-gencode-v1.gtf.gz

rm gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz
rm chrom_mapping.txt
