#!/bin/sh
set -eo pipefail -o nounset

cat << EOF > get_canonical_transcripts.py

import sys
import os
import io
import gzip 

gtf_file = sys.argv[1] ## A gtf file to filter

exon_count_by_transcript = dict()
## Get per transcript max exon count
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
for line in fh:
    if line[0] == "#":
        continue
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    if "transcript_id" in line_dict:
        if line_dict["feature"] == "exon":
            if line_dict["transcript_id"] not in exon_count_by_transcript:
                exon_count_by_transcript[line_dict["transcript_id"]] = int(line_dict["exon_number"])
            else:
                if int(line_dict["exon_number"]) > exon_count_by_transcript[line_dict["transcript_id"]]:
                    exon_count_by_transcript[line_dict["transcript_id"]] = int(line_dict["exon_number"])
fh.close()

def score_appris(appris_level):
    """
    Get a score between 0-7 based on the appris level
    """
    
    if appris_level == "appris_principal_1":
        return(1)
    if appris_level == "appris_principal_2":
        return(2)
    if appris_level == "appris_principal_3":
        return(3)
    if appris_level == "appris_principal_4":
        return(4)
    if appris_level == "appris_principal_5":
        return(5)
    if appris_level == "appris_alternative_1":
        return(6)
    if appris_level == "appris_alternative_2":
        return(7)
    return(1000)


def best_appris(first_appris, second_appris):
    """
    Get the best score appris level between two levels. 
    1 is returned if the first appris level is better then the second
    2 is returned if the second appris level is better then the first
    0 is returned if they are the same
    """
    
    first_appris_score = score_appris(first_appris)
    second_appris_score = score_appris(second_appris)
    if first_appris_score < second_appris_score:
        return(1)
    elif second_appris_score < first_appris_score:
        return(2)
    else:
        ## If the appris scores are the same, return "same"
        return(0)


primary_transcripts = dict()

## Parse the gtf file
## Identify canoncial transcript for each protein coding gene
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
for line in fh:
    if line[0] == "#":
        continue

    ## Update appris tag 
    appris_index = line.find("tag \"appris")
    if appris_index != -1:
        line = line[:appris_index] + "appris_tag" + line[appris_index + 3:]
    
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    
    ## Only look at transcripts
    if line_dict["feature"] == "transcript":
        ## Get only protein-coding only biotype 
        if line_dict["gene_type"] == "protein_coding":
            gene_id = line_dict["gene_id"]
            transcript_id = line_dict["transcript_id"] if "transcript_id" in line_dict else None

            ## Check for appris tag
            if "appris_tag" in line_dict:
                appris_level = line_dict["appris_tag"]
            else:
                appris_level = None

            ## cheack appris score
            if gene_id in primary_transcripts:
                best_appris_transcript = best_appris(appris_level, primary_transcripts[gene_id]["appris_level"])
                ## If new transcript has better appris level, replace transcript
                if best_appris_transcript == 1:
                    primary_transcripts[gene_id]["transcript_id"] = transcript_id
                    primary_transcripts[gene_id]["appris_level"] = appris_level

                ## If both transcripts are the same, use the one that is the largest 
                if best_appris_transcript == 0:
                    if transcript_id not in exon_count_by_transcript:
                        continue
                    if primary_transcripts[gene_id]["transcript_id"] not in exon_count_by_transcript:
                        continue
                    prev_exon_count = exon_count_by_transcript[primary_transcripts[gene_id]["transcript_id"]] 
                    cur_exon_count = exon_count_by_transcript[transcript_id]
                    ## if the exon count of the current transcript is greater then the one be stored, replace the old one
                    ## If the exon count is the same or the current transcript has less, don't replace
                    if cur_exon_count > prev_exon_count:
                        primary_transcripts[gene_id]["transcript_id"] = transcript_id
                        primary_transcripts[gene_id]["appris_level"] = appris_level
                        
            else:
                primary_transcripts[gene_id] = {"transcript_id": transcript_id,
                                                "appris_level": appris_level}

fh.close()
        

fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
header_added = False
for line in fh:
    if line[0] == "#":
        print(line.strip())
        continue
    if not header_added:
        header_added = True
        print("##Canonical Transcripts determined by APPRIS: APPRIS is a system to annotate alternatively spliced transcripts based on a range of computational methods.")
        print("##APPRIS Paper: https://academic.oup.com/nar/article/41/D1/D110/1054030")
        print("##APPRIS WebServer: http://appris-tools.org/#/")
        print("#" + "\t".join(header))
    
    ## Update appris tag 
    appris_index = line.find("tag \"appris")
    if appris_index != -1:
        line = line[:appris_index] + "appris_tag" + line[appris_index + 3:]
    
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    
    gene_id = line_dict["gene_id"]
    transcript_id = line_dict["transcript_id"] if "transcript_id" in line_dict else None

    if gene_id in primary_transcripts:
        if line_dict["feature"] == "gene":
            ## Keep gene features
            print(line.strip())
        elif transcript_id == primary_transcripts[gene_id]["transcript_id"]:
            print(line.strip())
                    
fh.close()


EOF


## Get .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.annotation.gtf.gz

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

python get_canonical_transcripts.py gencode.v34lift37.annotation.gtf.gz \
    | gsort --chromosomemappings  $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-canonical-transcripts-gencode-v1.gtf.gz

tabix grch37-canonical-transcripts-gencode-v1.gtf.gz

rm gencode.v34lift37.annotation.gtf.gz
rm get_canonical_transcripts.py
