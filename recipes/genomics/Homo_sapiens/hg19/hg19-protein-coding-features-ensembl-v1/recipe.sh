#!/bin/sh
set -eo pipefail -o nounset

cat << EOF > get_protein_coding_features.py

import sys
import os
import io 
import gzip

gtf_file = sys.argv[1] ## A gtf file to filter

fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(ar_gene_file, "rt", encoding = "utf-8")

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]

print("#" + "\t".join(header))

for line in fh:
    
    if line[0] == "#":
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    if "gene_biotype" in line_dict:

        if line_dict["gene_biotype"] == "protein_coding":
            
            print(line.strip())

fh.close()

EOF

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
wget --quiet $genome 

wget --quiet ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz 

## Get an array of scaffoldings not in the .genome file
myArray=($(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | cut -f 1 | sort | uniq | awk ' { if ( ($1 !~ /^#/ ) && (system("grep -Fq " $1 " GRCh37.genome") == 1) ) print $1}' ))

## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

cat <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep "^#") <(python get_protein_coding_features.py Homo_sapiens.GRCh37.75.gtf.gz) \
    | awk -v OFS="\t" -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($1 in chromDict) ) print $0 }' \
    | gsort --chromosomemappings $chr_mapping  /dev/stdin $genome2 \
    | bgzip -c > hg19-protein-coding-features-ensembl-v1.gtf.gz

tabix hg19-protein-coding-features-ensembl-v1.gtf.gz

## Remove extra files
rm GRCh37.genome
rm Homo_sapiens.GRCh37.75.gtf.gz
rm get_protein_coding_features.py
