#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome

## Get the NCBI Refseq ALL gtf file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/genes/hg19.ncbiRefSeq.gtf.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(zcat hg19.ncbiRefSeq.gtf.gz | cut -f 1 | sort | uniq | awk ' { if (system("grep -Fq " $1 " hg19.genome") == 1) print $1}' ))

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
gzip -dc hg19.ncbiRefSeq.gtf.gz \
    | awk -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($1 in chromDict) ) print $0 }' \
    | awk -v OFS="\t" 'BEGIN {print "#Data info: https://genome.ucsc.edu/cgi-bin/hgTrackUi?hgsid=828607149_h0XfhN0FSAO8AbnAAH5NX7hrZs6U&c=chr1&g=refSeqComposite\n#Data annotation = RefSeq All\n#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} 
                             {print $0}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome2 \
    | bgzip -c > grch37-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

tabix grch37-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

rm hg19.genome
rm hg19.ncbiRefSeq.gtf.gz
