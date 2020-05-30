#!/bin/sh
set -eo pipefail -o nounset



## Get genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get RADAR file, convert to bed, sort, bgzip, tabix 
wget --quiet -O - http://lilab.stanford.edu/GokulR/database/Human_AG_all_hg19_v2.txt \
    | awk -v OFS="\t" 'BEGIN { print "#RADAR Info: http://rnaedit.com/about/\n#chrom\tstart\tend\tgene\tstrand\tannot1\tannot2\talu?\tnon_alu_repetitive?\tconservation_chimp\tconservation_rhesus\tconservation_mouse"}
                             { if (NR > 1) print $1,$2-1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-radar-lielab-stranford-v1.bed.gz

tabix grch37-radar-lielab-stranford-v1.bed.gz

