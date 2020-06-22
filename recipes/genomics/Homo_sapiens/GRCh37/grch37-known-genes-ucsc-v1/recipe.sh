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
### 6 = NCBI protein Accession numbe
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
        kg_dict[line_list[0]] = [line_list[4].strip().replace(" ","-"),line_list[7].strip()]
        

with gzip.open(knowngene_file) as fh:
    for line in fh:
        try:
            line = line.decode("utf-8")
        except:
            pass

        line_list = line.strip().split("\t")

        ## Add the gene symobl to the line list
        symbol_and_description = kg_dict[line_list[0]] if line_list[0] in kg_dict else ["NA","NA"]
        line_list = symbol_and_description + line_list

        ## Print line seperated by tabs to stdout 
        print("\t".join(line_list))

EOF

## Get the knowgene file
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/knownGene.txt.gz 

## Get the kgXref file
## kgXref.txt.gz table info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=knownGene&hgta_table=kgXref&hgta_doSchema=describe+table+schema
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/kgXref.txt.gz


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

python map_knowngeneid_2_symbol.py kgXref.txt.gz knownGene.txt.gz \
    | awk -v OFS="\t" -v FS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=knownGene&hgta_table=knownGene&hgta_doSchema=describe+table+schema\n#chrom\ttxStart\ttxEnd\tstrand\tknowngene_ID\tgene_symbol\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tproteinID\tdescription"} 
                             {print $4,$6,$7,$5,$3,$1,$8,$9,$10,$11,$12,$13,$2}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-knowngenes-ucsc-v1.bed.gz

## Tabix file
tabix grch37-knowngenes-ucsc-v1.bed.gz

## Remove extra files
rm knownGene.txt.gz
rm kgXref.txt.gz
rm map_knowngeneid_2_symbol.py

