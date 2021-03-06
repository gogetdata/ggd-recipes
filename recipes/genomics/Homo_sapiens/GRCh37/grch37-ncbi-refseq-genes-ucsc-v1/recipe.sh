#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome

## Get the Refseq Genes file
wget --quiet  http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/ncbiRefSeq.txt.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(zcat ncbiRefSeq.txt.gz | cut -f 3 | sort | uniq | awk ' { if (system("grep -Fq " $1 " hg19.genome") == 1) print $1}' ))

## Get the chromosome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## get each row that does not have a scaffolding in "myArray". (That is, only keep scaffolding ids that are in the .genome file)
### Note; To use the "in" operator you need a awk dictionary. 
### Steps
##### 1) Convert myArray bash array to a awk array
##### 2) Convert awk array to a dictionary 
##### 3) Iterate over the repeat masker file, keeping only those that are not in the awk dictionary 
## Add header to filtered lines
## sort using gsort
## bgzip it 
gzip -dc ncbiRefSeq.txt.gz \
    | awk -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($3 in chromDict) ) print $0 }' \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=refSeqComposite&hgta_table=ncbiRefSeq&hgta_doSchema=describe+table+schema\n#chrom\ttxStart\ttxEnd\tstrand\ttranscript_id\tgene_id\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tcdsStartStatus\tcdsEndStatus\texonFrames"}
                               {print $3,$5,$6,$4,$2,$13,$7,$8,$9,$10,$11,$14,$15,$16}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome2 \
    | bgzip -c > grch37-ncbi-refseq-genes-ucsc-v1.bed.gz

tabix grch37-ncbi-refseq-genes-ucsc-v1.bed.gz


rm ncbiRefSeq.txt.gz
rm hg19.genome
