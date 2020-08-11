#!/bin/sh
set -eo pipefail -o nounset
wget -q http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/dgvSupporting.txt.gz
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome"
printf "#chrom\tchromStart\tchromEnd\tname\tscore\tstrand\tthickStart\tthickEnd\titemRgb\tvarType\treference\tpubMedId\tmethod\tplatform\tmergedVariants\tsupportingVariants\tsampleSize\tobservedGains\tobservedLosses\tcohortDescription\tgenes\tsamples\t_size" > dgvSupporting.txt

gunzip -c dgvSupporting.txt.gz | cut -f 2- >> dgvSupporting.txt
gsort dgvSupporting.txt $genome | bgzip -c > dgvSupporting.bed.gz
tabix dgvSupporting.bed.gz
rm dgvSupporting.txt.gz
rm dgvSupporting.txt
