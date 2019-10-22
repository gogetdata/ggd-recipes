#!/bin/sh
set -eo pipefail -o nounset
#!/bin/bash

set -euo pipefail

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget -q $genome
genome_loc="GRCh37.genome"

#Dang et al., manually curated HI set of genes
wget -q https://media.nature.com/original/nature-assets/ejhg/journal/v16/n11/extref/ejhg2008111x1.xls

#######################################################################################################
#nested python to convert from xls
cat << EOF > pyscript.py
from __future__ import print_function
import sys
import pyexcel as pe

book = pe.get_book(file_name=sys.argv[1])

genelist = open('haploinsufficient.tsv', 'w')

sheet = book['hap_with_blocks']
for i, record in enumerate(sheet):
    if i == 0:
        continue
    print(record[0], file=genelist)
genelist.close()
EOF

python pyscript.py ejhg2008111x1.xl\s

#######################################################################################################
grch37_gtf="$(ggd get-files grch37-gtf-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-gtf-ensembl-v1.gtf.gz')"
zless $grch37_gtf \
    | awk 'BEGIN { OFS="\t"} {if ( $3 == "CDS" || $3 == "stop_codon" ) print $0}' \
    | awk 'BEGIN { OFS="\t"} {$4=$4-1; print $0}' \
    | cut -f 1,4,5,12,16 \
    | sed 's/\"//g' \
    | sed 's/;//g' \
    | sed 's/ /\t/g' > coding_gene_file.bed



################################################################################################################
# matches gene names to bed coordinates
cat << EOF > parse_gene.py

"""
Get a list of genome coordinates for a list of ad genes
"""
import sys 

ad_gene_file = sys.argv[1] ## A single column tsv file for ad genes
coding_genes_file = sys.argv[2] ## A tsv file with 5 columns: 1: chrom, 2: start, 3: end, 4: transcript, 5: gene
outfile = sys.argv[3] ## File to write to

## Get a dict with keys = genes, values = empty []
with open(ad_gene_file, "r") as ad: 
    ad_gene_dict = {x.strip():[] for x in ad} 

## Add entries from coding gene file to dict based on gene
with open(coding_genes_file) as cg: 
    for line in cg: 
        line_list = line.strip().split("\t")
        gene = line_list[4] 
        if gene in ad_gene_dict:
            ad_gene_dict[gene].append(line)

## Write dict out
with open(outfile, "w") as o:
    for gene, coor in ad_gene_dict.items():
        o.write("".join(coor))

EOF
python parse_gene.py haploinsufficient.tsv coding_gene_file.bed unflattened_grch37-haploinsufficient-genes-clingen-v1.bed


################################################################################################################
cat << EOF > sort_columns.py
"""
sort the transcript id column
sort and get a unique list of the gene column
""" 
import sys
for line in sys.stdin.readlines():
    line_list = line.strip().split("\t")
    ## Sort column 4
    line_list[3] = ",".join(sorted(line_list[3].strip().split(",")))
    ## Sort column 5 and get a uniqe list
    line_list[4] = ",".join(sorted(list(set(line_list[4].strip().split(",")))))

    ## Print to stdout
    print("\t".join(line_list))

EOF


################################################################################################################
# creates flattened representation of protein-coding exome covering AD genes
gsort unflattened_grch37-haploinsufficient-genes-clingen-v1.bed $genome \
    | bedtools merge -c 4,5 -o collapse,collapse -i - \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tgene-id\tgene-name"} {print $0}' \
    | python sort_columns.py \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-haploinsufficient-genes-clingen-v1.bed.gz
tabix -p bed grch37-haploinsufficient-genes-clingen-v1.bed.gz

bedtools complement -i grch37-haploinsufficient-genes-clingen-v1.bed.gz -g $genome_loc  \
    | gsort /dev/stdin $genome \
    | sed '1d' \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz
tabix -p bed grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz

#cleanup
rm haploinsufficient.tsv
rm unflattened_grch37-haploinsufficient-genes-clingen-v1.bed
rm $genome_loc
rm ejhg2008111x1.xls
rm pyscript.py
rm parse_gene.py
rm sort_columns.py
rm coding_gene_file.bed
