#!/bin/sh
set -eo pipefail -o nounset
wget -q http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/dgvSupporting.txt.gz
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome"

printf "#chrom\tchromStart\tchromEnd\tname\tscore\tstrand\tthickStart\tthickEnd\titemRgb\tvarType\treference\tpubMedId\tmethod\tplatform\tmergedVariants\tsupportingVariants\tsampleSize\tobservedGains\tobservedLosses\tcohortDescription\tgenes\tsamples\t_size" > dgvSupporting.bed
gunzip -c dgvSupporting.txt.gz | cut -f 2- >> dgvSupporting.bed

gsort dgvSupporting.bed $genome | bgzip -c > dgvSupporting.bed.gz
tabix dgvSupporting.bed.gz
rm dgvSupporting.txt.gz
rm dgvSupporting.bed
