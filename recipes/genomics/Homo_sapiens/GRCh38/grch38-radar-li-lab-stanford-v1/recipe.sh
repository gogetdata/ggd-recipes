#!/bin/sh
set -eo pipefail -o nounset


## Get the liftover chain file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz

## Get the genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get RADAR file, convert to bed, sort, bgzip, tabix 
wget --quiet -O - http://lilab.stanford.edu/GokulR/database/Human_AG_all_hg19_v2.txt \
    | awk -v OFS="\t" '{if (NR > 1) print $1,$2-1,$2,$3,$7,$4,$5,$6,$8,$9","$10","$11}' > radar_temp.bed

## Liftover hg19 to hg38
CrossMap.py bed hg19ToHg38.over.chain.gz radar_temp.bed hg38-radar.bed

## Curate, sort, bgzip, and tabix new liftover file
cat hg38-radar.bed \
    | awk -v OFS="\t" 'BEGIN { print "#RADAR Info: http://rnaedit.com/about/\n#chrom\tstart\tend\tgene\tstrand\tannot1\tannot2\talu?\tnon_alu_repetitive?\tconservation_chimp\tconservation_rhesus\tconservation_mouse"}
                             { split($10,conserved,","); print $1,$2,$3,$4,$6,$7,$8,$5,$9,conserved[1], conserved[2], conserved[3]}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin  $genome \
    | bgzip -c > grch38-radar-lielab-stranford-v1.bed.gz

tabix grch38-radar-lielab-stranford-v1.bed.gz


## Remove extra files
rm hg19ToHg38.over.chain.gz
rm hg38-radar.bed.unmap
rm radar_temp.bed
rm hg38-radar.bed



