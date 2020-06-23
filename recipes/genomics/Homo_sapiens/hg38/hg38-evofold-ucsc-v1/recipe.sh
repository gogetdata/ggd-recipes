#!/bin/sh
set -eo pipefail -o nounset



## Get the liftover chain file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz

## Get the genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Download and process the hg19 evofold file and convert to bed format
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/evofold.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=evofold&hgta_table=evofold&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tUCSC_event_name\tsize\tscore\tstrand\tmRNAsecstruct\tsecondary_struct_conf"} 
                             {print $2,$3,$4,$5,$8,$6,$7,$9,$10}' > temp-evofold.bed

## Liftover from hg19 to hg38
CrossMap.py bed hg19ToHg38.over.chain.gz temp-evofold.bed hg38-evofold-ucsc.bed

## Sort and bgzip the hg38 litfover evofold file
cat hg38-evofold-ucsc.bed \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=evofold&hgta_table=evofold&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tUCSC_event_name\tsize\tscore\tstrand\tmRNAsecstruct\tsecondary_struct_conf"} 
                             {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-evofold-ucsc-v1.bed.gz 

## Tabix file
tabix hg38-evofold-ucsc-v1.bed.gz

## remove extra file
rm temp-evofold.bed
rm hg38-evofold-ucsc.bed
rm hg38-evofold-ucsc.bed.unmap 
rm hg19ToHg38.over.chain.gz
