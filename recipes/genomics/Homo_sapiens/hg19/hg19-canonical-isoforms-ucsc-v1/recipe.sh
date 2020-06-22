#!/bin/sh
set -eo pipefail -o nounset

cat << EOF > get_ensembl_gene_name.py

import os 
import io
import sys
import gzip

## knownToEnsembl
ucsc2ensembl_file = sys.argv[1]
## ensemblToGeneName
id2name_file = sys.argv[2]
## transcript2gene id
t2g_id_file = sys.argv[3]
## ucsc id to gene symbol
kg2symbol_file = sys.argv[4]
## known Genes
kg_file = sys.argv[5]
## knownCanonical
known_canonical_file = sys.argv[6]


## UCSC to Ensembl 
ucsc2ensembl_fh = gzip.open(ucsc2ensembl_file, "rt")

ucsc2ensembl_dict = {x.strip().split("\t")[0] : x.strip().split("\t")[1] for x in ucsc2ensembl_fh}

ucsc2ensembl_fh.close()
        

## Ensembl to gene symbol 
id2name_fh = gzip.open(id2name_file, "rt")

id2name_dict = {x.strip().split("\t")[0] : x.strip().split("\t")[1] for x in id2name_fh}

id2name_fh.close()


## Transcript to Gene id
t2g_id_fh = gzip.open(t2g_id_file, "rt")

t2g_id_dict = {x.strip().split("\t")[1] : x.strip().split("\t")[0] for x in t2g_id_fh}

t2g_id_fh.close()


## UCSC id to Gene symbol
ucsc2symbol_fh = gzip.open(kg2symbol_file, "rt")
header = ["kg_id","mran_id","spid","display_id","refseq_id","symbol","protacc","description","rfamacc","trnaname"]
ucsc2symbol_dict = dict()

for line in ucsc2symbol_fh:
    
    line_dict = dict(zip(header, line.strip().split("\t")))

    ucsc2symbol_dict[line_dict["kg_id"]] = line_dict["symbol"]

ucsc2symbol_fh.close()


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
    
    header = ["chrom","start","end","cluster_id","ucsc_id1","ucsc_id2"]
    
    print("#chrom\tstart\tend\tstrand\tucsc_id1\tucsc_id2\ttranscript_id\tgene_id\tgene_symbol")
    for line in kc_fh:
        line_dict = dict(zip(header,line.strip().split("\t")))


        ## Add gene info
        if line_dict["ucsc_id1"] in ucsc2ensembl_dict:
            line_dict["transcript_id"] = ucsc2ensembl_dict[line_dict["ucsc_id1"]]
            line_dict["gene_symbol"] = id2name_dict[line_dict["transcript_id"]]
            line_dict["gene_id"] = t2g_id_dict[line_dict["transcript_id"]]
        elif line_dict["ucsc_id1"] in kg2symbol:
            line_dict["transcript_id"] = "NA"
            line_dict["gene_id"] = "NA" 
            line_dict["gene_symbol"] = kg2symbol[line_dict["ucsc_id1"]] 
        elif line_dict["ucsc_id1"] in ucsc2symbol_dict:
            line_dict["transcript_id"] = "NA"
            line_dict["gene_id"] = "NA" 
            line_dict["gene_symbol"] = ucsc2symbol_dict[line_dict["ucsc_id1"]] 
        else:
            line_dict["transcript_id"] = "NA"
            line_dict["gene_symbol"] = "NA" 
            line_dict["gene_id"] = "NA" 
    

        ## Add strand info
        if line_dict["ucsc_id1"] in kg2strand:
            line_dict["strand"] = kg2strand[line_dict["ucsc_id1"]]
        else:
            line_dict["strand"] = "NA"
            


        print( line_dict["chrom"] + "\t" + line_dict["start"] + "\t" + line_dict["end"] + "\t" + line_dict["strand"] + "\t" + line_dict["ucsc_id1"] + "\t" + line_dict["ucsc_id2"] + "\t" + line_dict["transcript_id"] + "\t" + line_dict["gene_id"] + "\t" + line_dict["gene_symbol"])


EOF


## Get mapping files
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/knownToEnsembl.txt.gz

wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/ensemblToGeneName.txt.gz

wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/ensGtp.txt.gz

wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/kgXref.txt.gz

hg19_known_genes=$(ggd get-files hg19-known-genes-ucsc-v1 -p "*.bed.gz")

## Get the knowCanoncial files
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/knownCanonical.txt.gz

## Get the genome file
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome"

## Process the knownCanonical file
python get_ensembl_gene_name.py knownToEnsembl.txt.gz ensemblToGeneName.txt.gz ensGtp.txt.gz kgXref.txt.gz $hg19_known_genes knownCanonical.txt.gz \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=knownGene&hgta_table=knownCanonical&hgta_doSchema=describe+table+schema"}
                           { print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg19-knowngene-canonical-ucsc-v1.bed.gz

tabix hg19-knowngene-canonical-ucsc-v1.bed.gz


## Remove extra files
rm get_ensembl_gene_name.py 
rm knownToEnsembl.txt.gz 
rm ensemblToGeneName.txt.gz 
rm ensGtp.txt.gz 
rm kgXref.txt.gz 
rm knownCanonical.txt.gz 







