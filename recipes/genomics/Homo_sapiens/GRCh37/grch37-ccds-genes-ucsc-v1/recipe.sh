#!/bin/sh
set -eo pipefail -o nounset



## Get the .genoem file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")



cat << EOF > mapping_ccdsid.py

import gzip 
import os
import sys
import io

## Mapping file from HGNC
gene_info_file = sys.argv[1]
## CCDS current file
ccds_human = sys.argv[2]
## CCDS file
ccds_file = sys.argv[3]

## Mapping dict
ccds_mapping_dict = dict()

## Symbol Mapping
symbol_dict = dict()

with io.open(gene_info_file, "r", encoding="utf-8") as gene_info_fh:
    ## Get an index from the header 
    header_index = gene_info_fh.readline().strip().split("\t")
    ## Iterate over the file
    for i,line in enumerate(gene_info_fh):

        ## Get a dictionary for the current line
        line_dict = dict(zip(header_index, line.strip().split("\t")))
        
        ## Get gene symbol info
        gene_symbols = [x for x in line_dict["alias_symbol"].strip().replace("\"","").split("|")] if line_dict["alias_symbol"] else []
        gene_symbols.append(line_dict["symbol"])

        ## Get ccds ids mapping info
        ccds_ids = line_dict["ccds_id"].strip().replace("\"","").split("|") if "ccds_id" in line_dict else ""
        ensembl_gene_id = line_dict["ensembl_gene_id"] if "ensembl_gene_id" in line_dict else ""
        
        if ccds_ids and ensembl_gene_id:
            for ccds_id in ccds_ids:
                ccds_mapping_dict[ccds_id] = {"ensembl_id": ensembl_gene_id, "gene_symbol": line_dict["symbol"]}

        if gene_symbols:
            for symbol in gene_symbols:
                symbol_dict[symbol] = {"ensembl_id": ensembl_gene_id, "gene_symbol": symbol}


ccds_id_mapping_dict = dict()

with io.open(ccds_human, "r", encoding="utf-8") as cds_info_fh:
    ## Get an index from the header 
    header_index = cds_info_fh.readline().strip().split("\t")
    ## Iterate over the file
    for i,line in enumerate(cds_info_fh):

        ## Get a dictionary for the current line
        line_dict = dict(zip(header_index, line.strip().split("\t")))

        ccds_ids = line_dict["ccds_id"].strip().replace("\"","").split("|") if "ccds_id" in line_dict else ""
        gene_symbol = line_dict["gene"]  if "gene" in line_dict else ""
        
        if ccds_ids:
            for ccds_id in ccds_ids:
                if gene_symbol in symbol_dict:
                    ccds_id_mapping_dict[ccds_id] = symbol_dict[gene_symbol]
                else:
                    ccds_id_mapping_dict[ccds_id] = {"ensembl_id":"","gene_symbol": gene_symbol}



## The header and associated index 
ccds_file_header = {"bin":0,
                    "name":1,
                    "chrom":2,
                    "strand":3,
                    "txStart":4,
                    "txEnd":5,
                    "cdsStart":6,
                    "cdsEnd":7,
                    "exonCount":8,
                    "exonStart":9,
                    "exonEnd":10,
                    "score":11,
                    "name2":12,
                    "cdsStartStat":13,
                    "cdsEndStat":14,
                    "exonFrames":15}

with gzip.open(ccds_file, "rt") as ccds:

    for line in ccds:
        line_list = line.strip().split("\t")

        ## Use the name column, which is the CCDS id
        ccds_id = line_list[ccds_file_header["name"]]

        #if ccds_id in ccds_mapping_dict:
        if ccds_id in ccds_id_mapping_dict:
            mapped_dict = ccds_id_mapping_dict[ccds_id] 
            line_list.append(mapped_dict["ensembl_id"])
            line_list.append(mapped_dict["gene_symbol"])
        elif ccds_id in ccds_mapping_dict:
            mapped_dict = ccds_mapping_dict[ccds_id] 
            line_list.append(mapped_dict["ensembl_id"])
            line_list.append(mapped_dict["gene_symbol"])
        elif ccds_id.strip().split(".")[0] in ccds_mapping_dict:
            ccds_id = ccds_id.strip().split(".")[0] 
            mapped_dict = ccds_mapping_dict[ccds_id] 
            line_list.append(mapped_dict["ensembl_id"])
            line_list.append(mapped_dict["gene_symbol"])
        else:
            line_list.append("NA")
            line_list.append("NA")

        print("\t".join(line_list))


EOF


## Get the CCDS mapping info file
wget --quiet ftp://ftp.ebi.ac.uk/pub/databases/genenames/hgnc/tsv/locus_types/gene_with_protein_product.txt

## Get an additional CCDS mapping file
wget --quiet https://ftp.ncbi.nlm.nih.gov/pub/CCDS/current_human/CCDS.current.txt

## Process the ccds file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/ccdsGene.txt.gz 

python mapping_ccdsid.py gene_with_protein_product.txt CCDS.current.txt ccdsGene.txt.gz \
    | awk -v OFS="\t" -v FS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=ccdsGene&hgta_table=ccdsGene&hgta_doSchema=describe+table+schema\n#Consensus Coding Sequence (CCDS) Project URL: https://www.ncbi.nlm.nih.gov/CCDS/CcdsBrowse.cgi\n#chrom\ttxStart\ttxEnd\tstrand\tCCDS_id\tensembl_genet_id\tgene_symbol\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tcdsStartStatus\tcdsendStatus\texonFrame"}
                       { print $3,$5,$6,$4,$2,$17,$18,$7,$8,$9,$10,$11,$14,$15,$16}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-ccds-genes-ucsc-v1.bed.gz

tabix grch37-ccds-genes-ucsc-v1.bed.gz

## Remove files
rm mapping_ccdsid.py
rm gene_with_protein_product.txt
rm CCDS.current.txt
rm ccdsGene.txt.gz

