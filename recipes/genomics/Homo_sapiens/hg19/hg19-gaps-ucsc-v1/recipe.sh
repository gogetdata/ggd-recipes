#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet $genome

## get the file, 
## unzip it, 
## remove any lines that do not have a scaffolding in the hg19.genom file. (If scaffolding in hg19.genome, grep exists with 0)
## add header to the file, and remove the bin column
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 " hg19.genome") == 0)  print $0}' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=gap&hgta_table=gap&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > gaps.bed.gz

tabix gaps.bed.gz

rm hg19.genome
