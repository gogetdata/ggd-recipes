#!/bin/sh
set -eo pipefail -o nounset

## Get genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## Get RADAR file, convert to bed, sort, bgzip, tabix 
wget --quiet -O - http://lilab.stanford.edu/GokulR/database/Human_AG_all_hg19_v2.txt \
    | awk -v OFS="\t" 'BEGIN { print "#RADAR Info: http://rnaedit.com/about/\n#chrom\tstart\tend\tgene\tstrand\tannot1\tannot2\talu?\tnon_alu_repetitive?\tconservation_chimp\tconservation_rhesus\tconservation_mouse"}
                             { if (NR > 1) print $1,$2-1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-radar-lielab-stranford-v1.bed.gz

tabix hg19-radar-lielab-stranford-v1.bed.gz

