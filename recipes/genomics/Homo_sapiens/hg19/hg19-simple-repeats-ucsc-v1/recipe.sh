#!/bin/sh
set -eo pipefail -o nounset

## Get the genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet $genome

## Get simple repeats file
wget --quiet http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/simpleRepeat.txt.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(zcat simpleRepeat.txt.gz | cut -f 2 | sort | uniq | awk ' { if (system("grep -Fq " $1 " hg19.genome") == 1) print $1}' ))

## get each row that does not have a scaffolding in "myArray". (That is, only keep scaffolding ids that are in the .genome file)
### Note; To use the "in" operator you need a awk dictionary. 
### Steps
##### 1) Convert myArray bash array to a awk array
##### 2) Convert awk array to a dictionary 
##### 3) Iterate over the repeat masker file, keeping only those that are not in the awk dictionary 
gzip -dc simpleRepeat.txt.gz \
    | awk -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($2 in chromDict) ) print $0 }' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=rep&hgta_track=simpleRepeat&hgta_table=simpleRepeat&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tsequence\tscore\tstrand\tperiod\tcopy_num\tconsensusSize\tperMatch\tperIndel\tperA\tperC\tperG\tperT"} 
                        {print $2,$3,$4,$17,$11,"+",$6,$7,$8,$9,$10,$12,$13,$14,$15}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-simplerepeats-ucsc-v1.bed.gz

tabix hg19-simplerepeats-ucsc-v1.bed.gz

rm hg19.genome
rm simpleRepeat.txt.gz

