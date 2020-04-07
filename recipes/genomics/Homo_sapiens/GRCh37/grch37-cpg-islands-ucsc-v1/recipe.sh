#!/bin/sh
set -eo pipefail -o nounset

## Get the GRCh37.genom file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome


## Create filtered chromosome mapping file. If scaffolding not in genome file, remove it from the chromosome mapping file
chr_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
cat $chr_mapping | awk '{ if (system("grep -Fq " $2 " GRCh37.genome") == 0) print $0}' > grch37-chrom-mapping-filtered.txt


## Get the hg19 cpg island file and process it  
## unzip it, 
## remove any lines that do not have a scaffolding in the filtered chromosome mapping file. (If scaffolding in the filtered chromomsome mapping file, grep exists with 0)
## Get all columns but the first (bin column)
## add header to the file
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 " grch37-chrom-mapping-filtered.txt") == 0)  print $0}' \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=regulation&hgta_track=cpgIslandExt&hgta_table=cpgIslandExt&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tlength\tcpgNum\tgcNum\tperCpG\tperGC\tobsExp"} {print $0}' \
    | gsort --chromosomemappings grch37-chrom-mapping-filtered.txt /dev/stdin $genome \
    | bgzip -c > grch37-cpg-islands-ucsc-v1.bed.gz

## Tabix the processesed cpg file
tabix grch37-cpg-islands-ucsc-v1.bed.gz

rm GRCh37.genome
rm grch37-chrom-mapping-filtered.txt
