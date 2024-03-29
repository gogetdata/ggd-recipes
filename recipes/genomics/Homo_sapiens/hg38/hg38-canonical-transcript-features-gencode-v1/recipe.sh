#!/bin/sh
set -eo pipefail -o nounset
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
        ## Skip nonsense_mediated_decay transcripts
        if line_dict["transcript_type"] == "nonsense_mediated_decay":
            continue
        ## Skip readthrough transcripts:
        if "readthrough_transcript" in line:
            continue
        ## Get protein-coding only biotype 
        if line_dict["gene_type"] == "protein_coding" and line_dict["transcript_type"] == "protein_coding":
            gene_id = line_dict["gene_id"]
            gene_name = line_dict["gene_name"]
            transcript_id = line_dict["transcript_id"] if "transcript_id" in line_dict else None

            ## Check for appris tag
            if "appris_tag" in line_dict:
                appris_level = line_dict["appris_tag"]
            else:
                appris_level = None

            ## Check for MANE_Select
            if "MANE_Select" in line:
                mane = True
            else:
                mane = False
            

            ## cheack appris score
            if gene_id in primary_transcripts:
                best_appris_transcript = best_appris(appris_level, primary_transcripts[gene_id]["appris_level"])
                ## If new transcript has better appris level, replace transcript
                if best_appris_transcript == 1:
                    primary_transcripts[gene_id]["transcript_id"] = transcript_id
                    primary_transcripts[gene_id]["gene_name"] = gene_name
                    primary_transcripts[gene_id]["appris_level"] = appris_level
                    primary_transcripts[gene_id]["MANE"] = mane

                ## If both transcripts are the same, use the one that is the largest 
                if best_appris_transcript == 0:
                    if transcript_id not in exon_count_by_transcript:
                        continue
                    if primary_transcripts[gene_id]["transcript_id"] not in exon_count_by_transcript:
                        continue
                    ## Check the MANE tag
                    if mane and not primary_transcripts[gene_id]["MANE"]:
                        primary_transcripts[gene_id]["transcript_id"] = transcript_id
                        primary_transcripts[gene_id]["gene_name"] = gene_name
                        primary_transcripts[gene_id]["appris_level"] = appris_level
                        primary_transcripts[gene_id]["MANE"] = mane
                    else:
                        prev_exon_count = exon_count_by_transcript[primary_transcripts[gene_id]["transcript_id"]] 
                        cur_exon_count = exon_count_by_transcript[transcript_id]
                        ## if the exon count of the current transcript is greater then the one be stored, replace the old one
                        ## If the exon count is the same or the current transcript has less, don't replace
                        if cur_exon_count > prev_exon_count:
                            primary_transcripts[gene_id]["transcript_id"] = transcript_id
                            primary_transcripts[gene_id]["appris_level"] = appris_level
                            
            else:
                primary_transcripts[gene_id] = {"transcript_id": transcript_id,
                                                "gene_name": gene_name, 
                                                "appris_level": appris_level,
                                                "MANE": mane}

fh.close()


## Check for genes present more than once
gene_to_id = dict()
duplicate_genes = set()

for key, value in primary_transcripts.items():
    gene_name = value["gene_name"]

    if gene_name not in gene_to_id:
        gene_to_id[gene_name] = key
    else:   
        duplicate_genes.add(gene_name)
        if isinstance(gene_to_id[gene_name], str):
            gene_to_id[gene_name] = [gene_to_id[gene_name], key] 
        else:
            gene_to_id[gene_name].append(key) 


## Get the best gene id from the duplicate genes
best_gene_ids = set()
for gene in duplicate_genes:
    
    best_id = ""
    for gene_id in gene_to_id[gene]:

        ## If no best_id has been chosen make the first occurance the best
        if best_id == "":
            best_id = gene_id

        else:
            ## Check appris tags between the 'best' and current gene_id
            best_appris_transcript = best_appris(primary_transcripts[gene_id]["appris_level"], 
                                                 primary_transcripts[best_id]["appris_level"])

            ## New id has a better appris tag 
            if best_appris_transcript == 1:
                best_id = gene_id

            ## If the ids have the same appris tag
            if best_appris_transcript == 0:
                if primary_transcripts[gene_id]["MANE"] and not primary_transcripts[best_id]["MANE"]:
                    best_id = gene_id

            else:
                prev_exon_count = exon_count_by_transcript[primary_transcripts[best_id]["transcript_id"]] 
                cur_exon_count = exon_count_by_transcript[primary_transcripts[gene_id]["transcript_id"]]
                ## if the exon count of the current transcript is greater then the one be stored, replace the old one
                ## If the exon count is the same or the current transcript has less, don't replace
                if cur_exon_count > prev_exon_count:
                    best_id = gene_id

                    
    best_gene_ids.add(best_id)


## Remove duplicate gene
for gene in duplicate_genes:
    
    for gene_id in gene_to_id[gene]:

        if gene_id not in best_gene_ids:

            del primary_transcripts[gene_id]


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
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
wget --quiet $genome
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
wget --quiet $genome2

## Get hg38 chrom keys to filter final file with
cat <(echo "#") <(cut -f 1 hg38.genome) > hg38.keys

## Process GTF file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz

## Chrom mapping
chr_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

## If no chrom mapping, use existing patch/scaffolding name
gzip -dc gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz \
    | grep -v "^#" \
    | awk -v OFS="\t" '{ if ( ! ($1 ~ /^chr/ ) ) print $1}' \
    | uniq \
    | grep -f - GRCh38.genome >> hg38.genome

awk -v OFS="\t" '{ if (NF == 2) print $0}' $chr_mapping > chrom_mapping.txt

## Process, sort, and bgzip gtf 
python get_canonical_transcripts.py gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz \
    | gsort --chromosomemappings chrom_mapping.txt /dev/stdin hg38.genome \
    | grep -f hg38.keys \
    | bgzip -c > hg38-canonical-transcripts-gencode-v1.gtf.gz

tabix hg38-canonical-transcripts-gencode-v1.gtf.gz

## remove extra files
rm hg38.genome
rm hg38.keys
rm GRCh38.genome
rm gencode.v34.chr_patch_hapl_scaff.annotation.gtf.gz
rm chrom_mapping.txt
rm get_canonical_transcripts.py

