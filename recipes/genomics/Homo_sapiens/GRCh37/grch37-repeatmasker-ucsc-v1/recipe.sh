#!/bin/sh
set -eo pipefail -o nounset

## Get the genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome

## Get the chromosome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get repeat masker file
wget --quiet http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/rmsk.txt.gz \

## Get an array of scaffoldings not in the .genome file
myArray=($(zcat rmsk.txt.gz | cut -f 6 | sort | uniq | awk ' { if (system("grep -Fq " $1 " hg19.genome") == 1) print $1}' ))

## get each row that does not have a scaffolding in "myArray". (That is, only keep scaffolding ids that are in the .genome file)
### Note; To use the "in" operator you need a awk dictionary. 
### Steps
##### 1) Convert myArray bash array to a awk array
##### 2) Convert awk array to a dictionary 
##### 3) Iterate over the repeat masker file, keeping only those that are not in the awk dictionary 
gzip -dc rmsk.txt.gz \
    | awk -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($6 in chromDict) ) print $0 }' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=rep&hgta_track=rmsk&hgta_table=rmsk&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tstrand\trelativeStart\trelativeEnd\trepeatName\trepeatClass\trepeatFamily\tclass_family_name\tdiv\tdel\tins\tdiv+del+ins"} { print $6,$7,$8,$10,$14,$15,$11,$12,$13,$12"_"$13"_"$11,$3,$4,$5,$3+$4+$5}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome2 \
    | bgzip -c > grch37-repeatmasker-ucsc-v1.bed.gz

tabix grch37-repeatmasker-ucsc-v1.bed.gz

## Remove extra files
rm hg19.genome
rm rmsk.txt.gz
