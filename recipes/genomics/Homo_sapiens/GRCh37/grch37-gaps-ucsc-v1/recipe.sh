#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome
wget --quiet $genome2

## Create filtered chromosome mapping file. If scaffolding not in genome file, remove it from the chromosome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
cat $chrom_mapping | awk '{ if (system("grep -Fq " $2 " GRCh37.genome") == 0) print $0}' > grch37-chrom-mapping-filtered.txt

## get the file, 
## unzip it, 
## remove any lines that do not have a scaffolding in the GRCh37.genom file. (If scaffolding in grch37.genome, grep exists with 0)
## add header to the file, and remove the bin column
## sort it based on the genome file
## bgzip it
wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
    | gzip -dc \
    | awk '{ if (system("grep -Fq " $2 "  grch37-chrom-mapping-filtered.txt") == 0)  print $0}' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=map&hgta_track=gap&hgta_table=gap&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
    | gsort --chromosomemappings grch37-chrom-mapping-filtered.txt /dev/stdin $genome2 \
    | bgzip -c > grch37-gaps-ucsc-v1.bed.gz

## Tabix the processesed gaps file
tabix grch37-gaps-ucsc-v1.bed.gz

rm hg19.genome
rm GRCh37.genome
rm grch37-chrom-mapping-filtered.txt
