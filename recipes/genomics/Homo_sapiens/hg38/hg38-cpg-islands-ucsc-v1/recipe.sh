#!/bin/sh
set -eo pipefail -o nounset

## Get the hg38.genome file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Get the hg38 cpg island file and process it  
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=regulation&hgta_track=cpgIslandExt&hgta_table=cpgIslandExt&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tlength\tcpgNum\tgcNum\tperCpG\tperGC\tobsExp"} {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-cpg-islands-ucsc-v1.bed.gz

## Tabix the processesed cpg file
tabix hg38-cpg-islands-ucsc-v1.bed.gz
