#!/bin/sh
set -eo pipefail -o nounset

## Get the hg38.genome file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get Chrom mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
cp $chrom_mapping grch38-chrom-mapping.txt

## Get the hg38 gaps file and process it  
## unzip it, 
## remove any lines that do not have a scaffolding in the chrom_mapping file. 
## Get all columns but the first (bin column)
## add header to the file
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/gap.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 " grch38-chrom-mapping.txt") == 0)  print $0}' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=map&hgta_track=gap&hgta_table=gap&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-gaps-ucsc-v1.bed.gz

tabix grch38-gaps-ucsc-v1.bed.gz

## remove extra files
rm grch38-chrom-mapping.txt
