#!/bin/sh
set -eo pipefail -o nounset


## Get the hg38.genome file to sort 
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromosome mapping file 
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
cp $chrom_mapping grch38-chrom-mapping.txt


## Get the hg38 cpg island file and process it  
## unzip it, 
## remove any lines that do not have a scaffolding in the chrom_mapping file. 
## Get all columns but the first (bin column)
## add header to the file
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/cpgIslandExt.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 " grch38-chrom-mapping.txt") == 0)  print $0}' \
    | cut -f 2- \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=regulation&hgta_track=cpgIslandExt&hgta_table=cpgIslandExt&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tname\tlength\tcpgNum\tgcNum\tperCpG\tperGC\tobsExp"} {print $0}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-cpg-islands-ucsc-v1.bed.gz

## Tabix the processesed cpg file
tabix grch38-cpg-islands-ucsc-v1.bed.gz


## remove extra files
rm grch38-chrom-mapping.txt
