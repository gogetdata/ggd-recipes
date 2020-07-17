#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > get_canonical_transcripts.py

import sys
import os
import io
import gzip 

gtf_file = sys.argv[1] ## A gtf file to filter
appris_file = sys.argv[2] ## The appris principal data file used to filter 


exon_count_by_transcript = dict()

## Get per transcript max exon count
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(ar_gene_file, "rt", encoding = "utf-8")
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
    
    if appris_level == "PRINCIPAL:1":
        return(1)
    if appris_level == "PRINCIPAL:2":
        return(2)
    if appris_level == "PRINCIPAL:3":
        return(3)
    if appris_level == "PRINCIPAL:4":
        return(4)
    if appris_level == "PRINCIPAL:5":
        return(5)
    if appris_level == "ALTERNATIVE:1":
        return(6)
    if appris_level == "ALTERNATIVE:2":
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

## Get primary transcripts

primary_transcripts = dict()

fh = gzip.open(appris_file, "rt", encoding = "utf-8") if appris_file.endswith(".gz") else io.open(appris_file, "rt", encoding = "utf-8")

header = ["gene_symbol","gene_id","transcript_id","ccds_id","appris_level"]
for line in fh:
    
    line_dict = dict(zip(header, line.strip().split("\t")))

    if line_dict["gene_id"] not in primary_transcripts:
        primary_transcripts[line_dict["gene_id"]] = {"gene_symbol": line_dict["gene_symbol"], 
                                                     "transcript_id":line_dict["transcript_id"],
                                                     "appris_level":line_dict["appris_level"]
                                                    }

    else:
        ## If the new transcript appris level is better then the previous one, update. 
        best_appris_level = best_appris(primary_transcripts[line_dict["gene_id"]]["appris_level"], line_dict["appris_level"])
        if best_appris_level == 2:
            primary_transcripts[line_dict["gene_id"]] = {"gene_symbol": line_dict["gene_symbol"], 
                                                         "transcript_id":line_dict["transcript_id"],
                                                         "appris_level":line_dict["appris_level"]
                                                        }
        ## If they are the same, get the transcript with the most exons
        elif best_appris_level == 0:
            ## Skip if the transcript id is not in the exon_count_by_trancript dict
            if line_dict["transcript_id"] not in exon_count_by_transcript:
                continue
            if primary_transcripts[line_dict["gene_id"]]["transcript_id"] not in exon_count_by_transcript:
                continue

            prev_exon_count = exon_count_by_transcript[primary_transcripts[line_dict["gene_id"]]["transcript_id"]] 
            cur_exon_count = exon_count_by_transcript[line_dict["transcript_id"]]

            ## if the exon count of the current transcript is greater then the one be stored, replace the old one
            ## If the exon count is the same or the current transcript has less, don't replace
            if cur_exon_count > prev_exon_count:
                primary_transcripts[line_dict["gene_id"]] = {"gene_symbol": line_dict["gene_symbol"], 
                                                             "transcript_id":line_dict["transcript_id"],
                                                             "appris_level":line_dict["appris_level"]
                                                            }
        
fh.close()


            
## Parse the gtf file
## Print kept lines to stdout
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(ar_gene_file, "rt", encoding = "utf-8")
header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
header_added = False
for line in fh:
    if line[0] == "#":
        print(line.strip())
        continue
    if not header_added:
        header_added = True
        print("#!Canonical Transcripts determined by APPRIS: APPRIS is a system to annotate alternatively spliced transcripts based on a range of computational methods.")
        print("#!APPRIS Paper: https://academic.oup.com/nar/article/41/D1/D110/1054030")
        print("#!APPRIS WebServer: http://appris-tools.org/#/")
        print("#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute")

    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    
    ## Get only protein-coding only biotype 
    if line_dict["gene_biotype"] == "protein_coding":
        gene_id = line_dict["gene_id"]
        transcript_id = line_dict["transcript_id"] if "transcript_id" in line_dict else None

        ## Check that the gene has a canonical transcript
        if gene_id in primary_transcripts:
            if line_dict["feature"] == "gene":
                ## Keep gene features
                print(line.strip())

            elif transcript_id == primary_transcripts[gene_id]["transcript_id"]:
                print(line.strip() + " appris_level \"{}\";".format(primary_transcripts[gene_id]["appris_level"]))
                    


fh.close()

        
EOF


genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
chrom_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

wget --quiet ftp://ftp.ensembl.org/pub/release-100/gtf/homo_sapiens/Homo_sapiens.GRCh38.100.gtf.gz 

wget --quiet http://apprisws.bioinfo.cnio.es/pub/current_release/datafiles/homo_sapiens/GRCh38/appris_data.principal.txt

python get_canonical_transcripts.py Homo_sapiens.GRCh38.100.gtf.gz appris_data.principal.txt \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > hg38-canonical-transcript-features-ensembl-v1.gtf.gz

tabix hg38-canonical-transcript-features-ensembl-v1.gtf.gz

rm Homo_sapiens.GRCh38.100.gtf.gz
rm appris_data.principal.txt
rm get_canonical_transcripts.py
