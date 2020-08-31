#!/bin/sh
set -eo pipefail -o nounset

cat << EOF > get_utr_features.py

import sys
import os
import io 
import gzip
from collections import defaultdict

gtf_file = sys.argv[1] ## A gtf file to filter

fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]

transcript_info = defaultdict(lambda: defaultdict(list))

for line in fh:
    
    if line[0] == "#":
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    if line_dict["feature"] == "start_codon":

        transcript_info[line_dict["transcript_id"]]["start_codon"] = [line_dict["start"],line_dict["end"]]
        transcript_info[line_dict["transcript_id"]]["strand"] = line_dict["strand"]

    if line_dict["feature"] == "stop_codon":

        transcript_info[line_dict["transcript_id"]]["stop_codon"] = [line_dict["start"],line_dict["end"]]
        transcript_info[line_dict["transcript_id"]]["strand"] = line_dict["strand"]

    if line_dict["feature"] == "CDS":

        ## Get min and max CDS 
        if "CDS" in transcript_info[line_dict["transcript_id"]]:
            
            if int(line_dict["start"]) < int(transcript_info[line_dict["transcript_id"]]["CDS"][0]):
                transcript_info[line_dict["transcript_id"]]["CDS"][0] = line_dict["start"]   

            if int(line_dict["end"]) > int(transcript_info[line_dict["transcript_id"]]["CDS"][1]):
                transcript_info[line_dict["transcript_id"]]["CDS"][1] = line_dict["end"]   
        
        else:
            transcript_info[line_dict["transcript_id"]]["CDS"] = [line_dict["start"],line_dict["end"]]
            transcript_info[line_dict["transcript_id"]]["strand"] = line_dict["strand"]

fh.close()


fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")


print("#" + "\t".join(header))
for line in fh:
    
    if line[0] == "#":
        continue

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})

    if line_dict["feature"] == "UTR":
        
        ## Get strand
        strand = transcript_info[line_dict["transcript_id"]]["strand"]

        ## Get 5' and 3' positions  for the current transcript
        five_prime_side = transcript_info[line_dict["transcript_id"]]["start_codon"]
        three_prime_side = transcript_info[line_dict["transcript_id"]]["stop_codon"] 
        cds_region = transcript_info[line_dict["transcript_id"]]["CDS"]

        ## Get a list of elements from the current line
        line_list = line.strip().split("\t")

        if strand == "+": 

            ## If UTR is on the 5 prime side, it is a 5 prime UTR
            if five_prime_side and int(line_dict["end"]) < int(five_prime_side[0]):
                ## Set the line feature to 5 prime utr
                line_list[2] = "five_prime_utr"

            ## If no five prime positions, use the cds region positions
            elif cds_region and int(line_dict["end"]) < int(cds_region[0]):
                ## Set the line feature to 5 prime utr
                line_list[2] = "five_prime_utr"
            
            ## If UTR is on the 3 prime side, it is a 3 prime UTR
            if three_prime_side and int(line_dict["start"]) > int(three_prime_side[1]):
                ## Set the line feature to 3 prime utr
                line_list[2] = "three_prime_utr" 

            ## If no three prime positions, use the cds region positions
            elif cds_region and int(line_dict["start"]) > int(cds_region[1]):
                ## Set the line feature to 3 prime utr
                line_list[2] = "three_prime_utr" 

        elif strand == "-":

            ## If UTR is on the 5 prime side, it is a 5 prime UTR
            if five_prime_side and int(line_dict["start"]) > int(five_prime_side[1]):
                ## Set the line feature to 5 prime utr
                line_list[2] = "five_prime_utr"

            ## If no five prime positions, use the cds region positions
            elif cds_region and int(line_dict["start"]) > int(cds_region[1]):
                ## Set the line feature to 5 prime utr
                line_list[2] = "five_prime_utr"
            
            ## If UTR is on the 3 prime side, it is a 3 prime UTR
            if three_prime_side and int(line_dict["end"]) < int(three_prime_side[0]):
                ## Set the line feature to 3 prime utr
                line_list[2] = "three_prime_utr" 

            ## If no three prime positions, use the cds region positions
            elif cds_region and int(line_dict["end"]) < int(cds_region[0]):
                ## Set the line feature to 3 prime utr
                line_list[2] = "three_prime_utr" 
            

        print("\t".join(line_list))

fh.close()

EOF


## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz

gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz \
    | grep -v "^#" \
    | awk -v OFS="\t" 'BEGIN {print "chrM\tMT"} { if ( $1 != "chrM") gsub("chr","", $1); print "chr"$1, $1}' \
    | uniq >  chrom_mapping.txt

cat <(gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz | grep "^#") <(python get_utr_features.py gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz) \
    | gsort --chromosomemappings chrom_mapping.txt /dev/stdin $genome \
    | bgzip -c > grch38-protein-coding-features-gencode-v1.gtf.gz

tabix grch38-protein-coding-features-gencode-v1.gtf.gz

rm gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz
rm chrom_mapping.txt
rm get_utr_features.py
