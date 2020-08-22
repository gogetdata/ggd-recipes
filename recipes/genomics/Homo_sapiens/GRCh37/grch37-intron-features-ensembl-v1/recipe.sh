#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > add_introns.py

import sys
import os
import io
import gzip 
from collections import defaultdict

gtf_file = sys.argv[1] ## A gtf file to filter
genome_file = sys.argv[2] ## A .genome file

with io.open(genome_file, "rt", encoding = "utf-8") as gf:
    chrom_set = set([x.strip().split("\t")[0] for x in gf]) 

## Get per transcript exons
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")

exon_dict = defaultdict(list)

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
for line in fh:
    if line[0] == "#":
        continue
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    ## Add exon postiion to dict with transcript id as key
    if line_dict["feature"] == "exon":
        exon_dict[line_dict["transcript_id"]].append([int(line_dict["start"]),int(line_dict["end"])])
        
fh.close()

intron_dict = defaultdict(lambda: defaultdict(list))

for transcript_id, exon_list in exon_dict.items():
    
    ## Sort exon's by start position
    sorted_list = sorted(exon_list, key=lambda x: (x[0]))

    list_size = len(sorted_list)
    for i in range(list_size):

        ## if enough exons are available to create an intron
        if i + 1 < list_size:

            ## Intron start is exon end + 1
            intron_start = sorted_list[i][1] + 1

            ## Intron end is next exon start - 1
            intron_end = sorted_list[i+1][0] - 1

            ## Add intron to intron dict with keys as transcript id and exon position
            intron_dict[transcript_id]["{}-{}".format(sorted_list[i][0], sorted_list[i][1])] = [intron_start, intron_end]


## Get per transcript max exon count
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
print("#" + "\t".join(header))
for line in fh:
    if line[0] == "#":
        continue

    ## Skip scaffoldings not in the genome file
    if line.strip().split("\t")[0] not in chrom_set:
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    ## Print any intron lines
    if line_dict["feature"] == "exon":
        
        ## Skip intron creation if transcript not in intron dict
        if line_dict["transcript_id"] not in intron_dict:
            continue 

        ## Skip intron creation if exon key is not in intron dict
        if "{}-{}".format(line_dict["start"],line_dict["end"]) not in intron_dict[line_dict["transcript_id"]]:
            continue

        ## Get the intron positions from the intron dict
        intron_positions = intron_dict[line_dict["transcript_id"]]["{}-{}".format(line_dict["start"],line_dict["end"])]
        
        ## Create new line for intron entry
        intron_line = [str(line_dict["chrom"]), "ggd", "intron", str(intron_positions[0]), str(intron_positions[1]), ".", line_dict["strand"], "."]

        ## Get attribute info from the exon
        attributes = []

        if "gene_id" in line_dict:
            attributes.append("gene_id \"" + line_dict["gene_id"] + "\"")    

        if "gene_version" in line_dict:
            attributes.append("gene_version \"" + line_dict["gene_version"] + "\"")

        if "transcript_id" in line_dict:
            attributes.append("transcript_id \"" + line_dict["transcript_id"] + "\"") 

        if "transcript_version" in line_dict:
            attributes.append("transcript_version \"" + line_dict["transcript_version"] + "\"") 

        if "gene_name" in line_dict:
            attributes.append("gene_name \"" + line_dict["gene_name"] + "\"")

        if "gene_source" in line_dict:
            attributes.append("gene_source \"" + line_dict["gene_source"] + "\"")

        if "gene_biotype" in line_dict:
            attributes.append("gene_biotype \"" + line_dict["gene_biotype"] + "\"")

        if "transcript_name" in line_dict:
            attributes.append("transcript_name \"" + line_dict["transcript_name"] + "\"")

        if "transcript_source" in line_dict:
            attributes.append("transcript_source \"" + line_dict["transcript_source"] + "\"")

        if "transcript_biotype" in line_dict:
            attributes.append("transcript_biotype \"" + line_dict["transcript_biotype"] + "\"")

        ## Add feature info to the intron line
        intron_line.append("; ".join(attributes) + ";")

        ## Print intron line to stdout 
        print("\t".join(intron_line))
                    
fh.close()

EOF

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget --quiet $genome

wget --quiet ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz  

python add_introns.py Homo_sapiens.GRCh37.75.gtf.gz GRCh37.genome \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-gene-features-introns-only-v1.gtf.gz

tabix grch37-gene-features-introns-only-v1.gtf.gz

rm Homo_sapiens.GRCh37.75.gtf.gz
rm add_introns.py
rm GRCh37.genome
