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

    if "gene_type" in line_dict:

        if line_dict["gene_type"] == "protein_coding":
            
            print(line.strip())

fh.close()

EOF

## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.annotation.gtf.gz

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

cat <(gzip -dc gencode.v34lift37.annotation.gtf.gz | grep "^#") <(python get_protein_coding_features.py gencode.v34lift37.annotation.gtf.gz) \
    | gsort --chromosomemappings  $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-protein-coding-features-gencode-v1.gtf.gz

tabix grch37-protein-coding-features-gencode-v1.gtf.gz

rm gencode.v34lift37.annotation.gtf.gz
rm get_protein_coding_features.py
