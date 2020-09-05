#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > get_coding_features.py

import sys
import os
import io 
import gzip
from collections import defaultdict

gtf_file = sys.argv[1] ## A gtf file to filter

fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(ar_gene_file, "rt", encoding = "utf-8")

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]

transcript_cds_features = defaultdict(list)

for line in fh:
    
    if line[0] == "#":
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    if line_dict["feature"] == "CDS":

        ## 2d list, where each inner list represents a start and end position of a CDS region
        transcript_cds_features[line_dict["transcript_id"]].append([line_dict["start"], line_dict["end"]])
        
fh.close()



print("#" + "\t".join(header))
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(ar_gene_file, "rt", encoding = "utf-8")

for line in fh:
    
    if line[0] == "#":
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    ## get exon feature
    if line_dict["feature"] == "exon" and "gene_biotype" in line_dict:

        ## Get protein coding gene
        if line_dict["gene_biotype"] == "protein_coding":
            
            ## Check exon for overlap with cds region
            for cds_region in transcript_cds_features[line_dict["transcript_id"]]:

                ## if exon start is less than cds end and exon end is greater then cds start, feature overlaps cds region
                if line_dict["start"] < cds_region[1] and line_dict["end"] > cds_region[0]:
                
                    print(line.strip())
                    break

fh.close()

EOF



## GET CDS Regions
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome 

wget --quiet ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz 

## Get Protein coding exons
## Get an array of scaffoldings not in the .genome file
myArray=($(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | cut -f 1 | sort | uniq | awk ' { if ( ($1 !~ /^#/ ) && (system("grep -Fq " $1 " GRCh37.genome") == 1) ) print $1}' ))

cat <(gzip -dc Homo_sapiens.GRCh37.75.gtf.gz | grep "^#") <(python get_coding_features.py Homo_sapiens.GRCh37.75.gtf.gz) \
    | awk -v OFS="\t" -v bashArray="${myArray[*]}" 'BEGIN{ split(bashArray,chromList); for (i in chromList) chromDict[chromList[i]] = chromList[i] } { if ( !($1 in chromDict) ) print $0 }' \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-coding-exons-ensembl-v1.gtf.gz

tabix grch37-coding-exons-ensembl-v1.gtf.gz


## Remove extra files
rm GRCh37.genome
rm Homo_sapiens.GRCh37.75.gtf.gz
rm get_coding_features.py




