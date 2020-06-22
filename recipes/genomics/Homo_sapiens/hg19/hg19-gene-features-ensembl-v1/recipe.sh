#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet $genome 

## Get the GTF file from Ensembl
wget --quiet ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | cut -f 1 | sort | uniq | awk ' { if ( ($1 !~ /^#/ ) && (system("grep -Fq " $1 " GRCh37.genome") == 1) ) print $1}' ))

## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## Process gtf file
cat <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep "^#") <(echo -e "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute") <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep -v "^#") \
    | awk -v OFS="\t" -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($1 in chromDict) ) print $0 }' \
    | gsort --chromosomemappings $chr_mapping  /dev/stdin $genome2 \
    | bgzip -c > hg19-gene-features-ensembl-v1.gtf.gz

tabix hg19-gene-features-ensembl-v1.gtf.gz

## Remove extra files
rm GRCh37.genome
rm Homo_sapiens.GRCh37.75.gtf.gz
