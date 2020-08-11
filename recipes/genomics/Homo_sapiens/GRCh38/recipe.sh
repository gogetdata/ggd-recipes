#!/bin/sh
set -eo pipefail -o nounset
set -e
wget -q http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/dgvSupporting.txt.gz
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome"
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

printf "#chrom\tchromStart\tchromEnd\tname\tscore\tstrand\tthickStart\tthickEnd\titemRgb\tvarType\treference\tpubMedId\tmethod\tplatform\tmergedVariants\tsupportingVariants\tsampleSize\tobservedGains\tobservedLosses\tcohortDescription\tgenes\tsamples\t_size" > dgvSupporting.bed
gunzip -c dgvSupporting.txt.gz | cut -f 2- >> dgvSupporting.bed

gsort --chromosomemappings $chrom_mapping dgvSupporting.bed $genome | bgzip -c > dgvSupporting.bed.gz
tabix dgvSupporting.bed.gz
rm dgvSupporting.txt.gz
rm dgvSupporting.bed
