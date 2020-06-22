#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > get_ensembl_gene_name.py

import os 
import io
import sys
import gzip

## The known gene file
kg_file = sys.argv[1]
## The known Canonical file
known_canonical_file = sys.argv[2]

## Known Gense 
kg_fh = gzip.open(kg_file, "rt")

kg_fh.readline()
header = kg_fh.readline().strip().split("\t")

kg2symbol = dict()
kg2strand = dict()

for line in kg_fh:
    line_dict = dict(zip(header,line.strip().split("\t")))
    kg2symbol[line_dict["knowngene_ID"]] = line_dict["gene_symbol"]
    kg2strand[line_dict["knowngene_ID"]] = line_dict["strand"]

kg_fh.close()
        

with gzip.open(known_canonical_file, "rt") as kc_fh:
    
    header = ["chrom","start","end","cluster_id","transcript_id","gene_id"]
    
    print("#chrom\tstart\tend\tstrand\ttranscript_id\tgene_id\tgene_symbol")
    for line in kc_fh:
        line_dict = dict(zip(header,line.strip().split("\t")))

        ## Add symbol info
        if line_dict["transcript_id"] in kg2symbol:
            line_dict["gene_symbol"] = kg2symbol[line_dict["transcript_id"]] 
        else:
            line_dict["gene_symbol"] = "NA" 

        ## Add strand info
        if line_dict["transcript_id"] in kg2strand:
            line_dict["strand"] = kg2strand[line_dict["transcript_id"]]
        else:
            line_dict["strand"] = "NA"

        print(line_dict["chrom"] + "\t" + line_dict["start"] + "\t" + line_dict["end"] + "\t" + line_dict["strand"] + "\t" + line_dict["transcript_id"] + "\t" + line_dict["gene_id"] + "\t" + line_dict["gene_symbol"])


EOF

        

## Get the hg38 known gene file
hg38_known_genes=$(ggd get-files hg38-known-genes-ucsc-v1 -p "*.bed.gz")

## Get the known canonical file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/knownCanonical.txt.gz

## Get the genome file
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome"

## Process the canonical file
python get_ensembl_gene_name.py $hg38_known_genes knownCanonical.txt.gz \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=genes&hgta_track=knownGene&hgta_table=knownCanonical&hgta_doSchema=describe+table+schema"}
                           { print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-knowngene-canonical-ucsc-v1.bed.gz

tabix hg38-knowngene-canonical-ucsc-v1.bed.gz


rm get_ensembl_gene_name.py
rm knownCanonical.txt.gz
