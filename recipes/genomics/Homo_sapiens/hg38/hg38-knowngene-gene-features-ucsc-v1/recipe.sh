#!/bin/sh
set -eo pipefail -o nounset


cat << EOF > map_knowngeneid_2_symbol.py

"""
Map the UCSC knownGene Ids to gene symbols
"""

import sys
import gzip
from collections import defaultdict

## kgXref.txt.gz table info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=knownGene&hgta_table=kgXref&hgta_doSchema=describe+table+schema
## Columns: 
### 1 = Known Gene ID
### 2 = mRNA ID
### 3 = UniProt protein Accession number
### 4 = UniProt display ID
### 5 = Gene Symbol
### 6 = NCBI protein Accession number
### 7 = Description
### 8 = Rfam accession number
### 9 = Name from the tRNA track
mapping_file = sys.argv[1] ## The kgXref.txt.gz file from UCSC 
knowngene_file = sys.argv[2] ## The knowgene file from UCSC

kg_dict = defaultdict(str)
with gzip.open(mapping_file) as fh:
    for line in fh:
        try:
            line = line.decode("utf-8")
        except:
            pass

        line_list = line.strip().split("\t")
        ## key = kgID, value = [gene symbol,description]
        kg_dict[line_list[0]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[1]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[2]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[3]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[4]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[5]] = line_list[4].strip().replace(" ","-")
        kg_dict[line_list[6]] = line_list[4].strip().replace(" ","-")
        
assert "ENST00000340131.12" in kg_dict

with gzip.open(knowngene_file) as fh:
    for line in fh:
        try:
            line = line.decode("utf-8")
        except:
            pass

        line_list = line.strip().split("\t")

        ## get a list of attributes
        attributes = line_list[8].strip().split(";")

        ## Remove empty attribute
        del attributes[-1]
        
        ## Get the gene symbol for the list of attributes
        for attribute in attributes:
            attribute_list = attribute.strip().split(" ")
            if attribute_list[0].strip() in ["gene_id","gene_name","transcript_id","exon_id"]:
                gene_symbol = kg_dict[eval(attribute_list[1].strip()).split("_")[0]] if eval(attribute_list[1].strip()).split("_")[0] in kg_dict else "NA" 
                break

        ## Add the gene symbol to the list of attributes
        attributes.append(" gene_symbol \"{}\";".format(gene_symbol))

        ## add the attributes back to the line_list
        line_list[8] = ";".join(attributes)

        ## Print line seperated by tabs to stdout 
        print("\t".join(line_list))

EOF


## Get the known genes gtf file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.knownGene.gtf.gz  

## get the kgXref.txt.gz file
## kgXref.txt.gz table info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=genes&hgta_track=knownGene&hgta_table=kgXref&hgta_doSchema=describe+table+schema
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/kgXref.txt.gz

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome


python map_knowngeneid_2_symbol.py kgXref.txt.gz hg38.knownGene.gtf.gz \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: http://genome.ucsc.edu/cgi-bin/hgTrackUi?db=hg38&g=knownGene\n#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} 
                             {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-knowngenes-gene-features-ucsc-v1.gtf.gz

tabix hg38-knowngenes-gene-features-ucsc-v1.gtf.gz


## Remove extra files
rm hg38.knownGene.gtf.gz
rm kgXref.txt.gz
rm map_knowngeneid_2_symbol.py
