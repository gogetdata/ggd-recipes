#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome 

wget --quiet ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | cut -f 1 | sort | uniq | awk ' { if ( ($1 !~ /^#/ ) && (system("grep -Fq " $1 " GRCh37.genome") == 1) ) print $1}' ))

cat <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep "^#") <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep -v "^#") \
    | awk -v OFS="\t" -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($1 in chromDict) ) print $0 }' \
    | awk -v OFS="\t" 'BEGIN{print "#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} { if ( $3 == "CDS") print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-cds-only-features-ensembl-v1.gtf.gz

tabix grch37-cds-only-features-ensembl-v1.gtf.gz

## Remove extra files
rm GRCh37.genome
rm Homo_sapiens.GRCh37.75.gtf.gz




