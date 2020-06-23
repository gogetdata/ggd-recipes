#!/bin/sh
set -eo pipefail -o nounset
## Get the hg19.genome file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet $genome

## Get the hg19 cpg island file and process it  
## unzip it, 
## remove any lines that do not have a scaffolding in the hg19.genome file. (If scaffolding in hg19.genome, grep exists with 0)
## Get all columns but the first (bin column)
## add header to the file
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 " hg19.genome") == 0)  print $0}' \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=regulation&hgta_track=cpgIslandExt&hgta_table=cpgIslandExt&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tlength\tcpgNum\tgcNum\tperCpG\tperGC\tobsExp"} {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-cpg-islands-ucsc-v1.bed.gz

## Tabix the processesed cpg file
tabix hg19-cpg-islands-ucsc-v1.bed.gz

rm hg19.genome
