#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > grch37_to_grch38.py
import os
import sys
import gzip

gtf_file = sys.argv[1]
bed_file = sys.argv[2]

transcript_dict = dict()
gene_dict = dict()

header = ["chrom","source","feature","start","end","score","strand","frame","attribute"]
with gzip.open(gtf_file, "rt", encoding = "utf-8") as gtf:

    for i,line in enumerate(gtf):
        
        if line[0] == "#":
            continue

        entry = dict(zip(header,line.strip().split("\t")))

        ## Only looking at exon and transcripts
        if entry["feature"] in ["exon","transcript"]:

            entry.update({x.strip().replace("\"","").split(" ")[0] : x.strip().replace("\"","").split(" ")[1] for x in entry["attribute"].strip().split(";")[:-1]})

            
            if entry["transcript_id"] not in transcript_dict:
                transcript_dict[entry["transcript_id"]] = {"exon_number":0}

            if entry["feature"] == "transcript":
                transcript_dict[entry["transcript_id"]]["chrom"] = entry["chrom"]
                transcript_dict[entry["transcript_id"]]["txStart"] = entry["start"]
                transcript_dict[entry["transcript_id"]]["txEnd"] = entry["end"]
                transcript_dict[entry["transcript_id"]]["strand"] = entry["strand"]
                transcript_dict[entry["transcript_id"]]["gene_symbol"] = entry["gene_name"]

            else:
                if int(entry["exon_number"]) > int(transcript_dict[entry["transcript_id"]]["exon_number"]):
                    transcript_dict[entry["transcript_id"]]["exon_number"] = int(entry["exon_number"])


        elif entry["feature"] == "gene": 

            entry.update({x.strip().replace("\"","").split(" ")[0] : x.strip().replace("\"","").split(" ")[1] for x in entry["attribute"].strip().split(";")[:-1]})



            if entry["gene_biotype"] != "protein_coding":
                continue

            if entry["gene_name"] not in gene_dict:
                gene_dict[entry["gene_name"]] = dict()

            gene_dict[entry["gene_name"]]["chrom"] = entry["chrom"]
            gene_dict[entry["gene_name"]]["start"] = entry["start"]
            gene_dict[entry["gene_name"]]["end"] = entry["end"]
            gene_dict[entry["gene_name"]]["strand"] = entry["strand"]

        else:
            continue


with gzip.open(bed_file, "rt", encoding = "utf-8") as bed:
    
    header = bed.readline().strip().split("\t")

    for line in bed:
        
        line_dict = dict(zip(header, line.strip().split("\t")))
        
        t_id = line_dict["transcript_id"] if line_dict["transcript_id"] in transcript_dict else line_dict["transcript_id"].strip().split(".")[0]

        if t_id in transcript_dict:
            
            chrom = str(transcript_dict[t_id]["chrom"])
            start = str(int(transcript_dict[t_id]["txStart"]) - 1) ## Update from 1 based gtf to 0 based bed
            end = str(transcript_dict[t_id]["txEnd"])
            gene = str(transcript_dict[t_id]["gene_symbol"])
            strand = str(transcript_dict[t_id]["strand"])
            exon_number = str(transcript_dict[t_id]["exon_number"])

        elif line_dict["gene_symbol"] in gene_dict:

            gene = str(line_dict["gene_symbol"])
            chrom = str(gene_dict[gene]["chrom"])
            start = str(int(gene_dict[gene]["start"]) -1 ) ## Update from 1 based gtf to 0 based bed
            end = str(gene_dict[gene]["end"])
            t_id = "Unable-to-Map-to-GRCh38"
            strand = str(gene_dict[gene]["strand"])
            exon_number = "(NA)-Gene-Used-Rather-Than-Transcript"

        else:
            continue

        print("\t".join([chrom,
                        start,
                        end,
                        gene,
                        t_id,
                        strand,
                        exon_number,
                        str(line_dict["missense_z_score"])]))
EOF


## get the .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the missense z score from the gnomad donwload site
wget --quiet -O - https://storage.googleapis.com/gnomad-public/legacy/exac_browser/forweb_cleaned_exac_r03_march16_z_data_pLI_CNV-final.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\ttxStart\ttxEnd\tgene_symbol\ttranscript_id\tn_exons\tn_base_pairs\tmissense_z_score"} 
                             { if (NR > 1) print $3,$5,$6,$2,$1,$4,$7,$18}' \
    | gsort /dev/stdin $genome \
    | uniq \
    | bgzip -c > missense-z-exac-v1.bed.gz


## get the .genome file
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
gtf_file=$(ggd get-files grch38-gene-features-ensembl-v1 --pattern "*.gtf.gz")

python grch37_to_grch38.py $gtf_file missense-z-exac-v1.bed.gz \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tgene\ttranscript_id\tstrand\texon_number\tmissense_z_score"}
                             {print $0} '\
    | gsort /dev/stdin $genome2 \
    | bgzip -c > grch38-missense-z-exac-v1.bed.gz

tabix grch38-missense-z-exac-v1.bed.gz


rm missense-z-exac-v1.bed.gz
rm grch37_to_grch38.py


