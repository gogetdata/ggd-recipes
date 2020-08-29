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

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ensembl.org/pub/release-100/gtf/homo_sapiens/Homo_sapiens.GRCh38.100.gtf.gz 

cat <(gzip -dc Homo_sapiens.GRCh38.100.gtf.gz | grep "^#") <(python get_protein_coding_features.py Homo_sapiens.GRCh38.100.gtf.gz) \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-protein-coding-features-ensembl-v1.gtf.gz

tabix grch38-protein-coding-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.100.gtf.gz
rm get_protein_coding_features.py
