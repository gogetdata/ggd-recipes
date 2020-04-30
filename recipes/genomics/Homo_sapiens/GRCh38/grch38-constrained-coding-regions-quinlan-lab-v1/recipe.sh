#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get autosomes CCRs, sort them, bgzip file
wget --quiet -O - https://s3.us-east-2.amazonaws.com/ccrs/ccrs/ccrs.autosomes.v2.20180420.bed.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz

## Get X chrom CCRs, sort them, bgzip file
wget --quiet -O - https://s3.us-east-2.amazonaws.com/ccrs/ccrs/ccrs.xchrom.v2.20180420.bed.gz \
    | gzip -dc \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz

## Get the GRCh37 to GRCh38 chain file from Ensembl for liftover
wget --quiet ftp://ftp.ensembl.org/pub/assembly_mapping/homo_sapiens/GRCh37_to_GRCh38.chain.gz

## Autosome
## Get the stdout from the CrossMap liftover
### Use only the chrom, start, and end from the ccr file
gzip -dc grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz | cut -f 1,2,3 | CrossMap.py bed GRCh37_to_GRCh38.chain.gz /dev/stdin > grch37_to_grch38.autosome.liftover.out 


## X Chromsome 
## Get the stdout from the CrossMap liftover
### Use only the chrom, start, and end from the ccr file
gzip -dc grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz | cut -f 1,2,3 | CrossMap.py bed GRCh37_to_GRCh38.chain.gz /dev/stdin > grch37_to_grch38.X.liftover.out 

cat << EOF > coordinance_liftover.py

"""
Remapped CCR coordinance based on the liftover output file from Grossmap.py
"""
import os
import sys
from collections import defaultdict
import pandas as pd
import numpy as np

## Liftover file. This file is the stdout file from the Crossmap liftover tool 
### Command = Crossmap.py bed chain_file ccr_bed_file > grch37_to_grch38.liftover.out
#### Note: Command is missing an output file. The stdout output should be captured in an output file
liftover_file = sys.argv[1]
## THe ccr bed file
ccr_file = sys.argv[2]

## Dict for mapping liftover coordinates
liftover_dict = defaultdict(lambda: defaultdict(str))

## Open liftover file
with open(liftover_file) as lo:

    ## iterate over liftover file
    for line in lo:
        line_list = line.strip().split("\t")

        ## Set unmapped regions to an empty string
        if "Unmap" in line_list[3]:
           original = "{}-{}".format(line_list[1].strip(),line_list[2].strip()) ## Start and end of before liftover coordinances
           liftover_dict[line_list[0]][original] = ""
           continue

        ## Make sure the chroms are the same
        assert line_list[0] == line_list[4] 

        ## Get before and after coordinates
        original = "{}-{}".format(line_list[1],line_list[2]) ## Start and end of before liftover coordinances
        new = "{}-{}".format(line_list[5],line_list[6]) ## Start and end of after liftover coordinances

        ## Add to liftover dict
        liftover_dict[line_list[0]][original] = new

## Read in ccr bed file
ccr_df = pd.read_csv(ccr_file, sep="\t", dtype={"#chrom": str})

## Temp list for holding temp liness
line_holder = []


print("\t".join(ccr_df.columns.to_list()))
## Iterate over ccr bed file, update start and end postiion with linftover coordinates, and update range coordinates 
for index, row in ccr_df.iterrows():

    chrom = row["#chrom"]
    start_end = "{}-{}".format(row.start,row.end)

    ## Check if start and end coordinates are in the liftover dict
    if start_end not in liftover_dict[chrom]:
        print("\n!!Error!! Missing coordinates: {}:{}".format(chrom,start_end))
        sys.exit(1)

    ## Get the new start and end coordinates from the liftover dict
    new_start_end = liftover_dict[chrom][start_end] 

    ## If region is remapped/lifted over
    if new_start_end != "":
        
        ## Get new start 
        new_start = new_start_end.strip().split("-")[0]

        ## Get new end
        new_end = new_start_end.strip().split("-")[1]
        
        ## get new ranges
        new_ranges = [liftover_dict[chrom][r] for r in row.ranges.strip().split(",")]

        ## Update row
        new_line = [str(chrom),str(new_start),str(new_end),str(row.ccr_pct),str(row.gene),",".join(new_ranges),str(row.varflag),str(row.syn_density),str(row.cpg),str(row.cov_score),str(row.resid),str(row.resid_pctile),str(row.unique_key)]

        ## Print new row to stdout
        print("\t".join(new_line))


EOF

## Liftover the grch37 autosome ccr file to grch38
python coordinance_liftover.py grch37_to_grch38.autosome.liftover.out grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz \
    | gsort /dev/stdin $genome2 \
    | bgzip -c > grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz

tabix --csi grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz

## Liftover the grch37 X ccr file to grch38
python coordinance_liftover.py  grch37_to_grch38.X.liftover.out grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz \
    | gsort /dev/stdin $genome2 \
    | bgzip -c > grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz

tabix --csi grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz

## Remove b37 files
rm grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz
rm grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz
rm grch37_to_grch38.autosome.liftover.out
rm grch37_to_grch38.X.liftover.out
rm GRCh37_to_GRCh38.chain.gz 
rm coordinance_liftover.py



