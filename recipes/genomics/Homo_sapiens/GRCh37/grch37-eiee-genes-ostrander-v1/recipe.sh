#! /bin/sh
#set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget -q $genome
genome_loc="GRCh37.genome"

#eiee genes
wget -q https://static-content.springer.com/esm/art%3A10.1038%2Fs41525-018-0061-8/MediaObjects/41525_2018_61_MOESM1_ESM.xlsx

#######################################################################################################
#nested python to convert from xls
cat << EOF > pyscript.py
from __future__ import print_function
import sys
import pyexcel as pe

book = pe.get_book(file_name=sys.argv[1])

genelist = open('eiee_genes.tsv', 'w')

sheet = book['Supp Table 4']
for i, record in enumerate(sheet):
    if i == 0:
        continue
    print(record[0], file=genelist)
genelist.close()
EOF
python pyscript.py 41525_2018_61_MOESM1_ESM.xlsx


#######################################################################################################
grch37_gtf="$(ggd get-files grch37-gtf-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-gtf-ensembl-v1.gtf.gz')"
#only grabs protein coding sequence
zless $grch37_gtf \
    | awk 'BEGIN { OFS="\t"} {if ( $3 == "CDS" || $3 == "stop_codon" ) print $0}' \
    | awk 'BEGIN { OFS="\t"} {$4=$4-1; print $0}' \
    | cut -f 1,4,5,12,16 \
    | sed 's/\"//g' \
    | sed 's/;//g' \
    | sed 's/ /\t/g' > coding_gene_file.bed


cat << EOF > parse_gene.py

"""
Get a list of genome coordinates for a list of ad genes
"""
import sys 

tsv_file = sys.argv[1] ## A single column tsv file 
coding_genes_file = sys.argv[2] ## A bed file with 5 columns: 1: chrom, 2: start, 3: end, 4: transcript, 5: gene
outfile = sys.argv[3] ## File to write to

## Get a dict with keys = genes, values = empty []
with open(tsv_file, "r") as ad: 
    gene_dict = {x.strip():[] for x in ad} 

## Add entries from coding gene file to dict based on gene
with open(coding_genes_file) as cg: 
    for line in cg: 
        line_list = line.strip().split("\t")
        gene = line_list[4] 
        if gene in gene_dict:
            gene_dict[gene].append(line)

## Write dict out
with open(outfile, "w") as o:
    for gene, coor in gene_dict.items():
        o.write("".join(coor))

EOF
python parse_gene.py eiee_genes.tsv coding_gene_file.bed unflattened_grch37-eiee-genes-ostrander-v1.bed 

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

# creates flattened representation of protein-coding exome covering AD genes
gsort unflattened_grch37-eiee-genes-ostrander-v1.bed $genome \
    | bedtools merge -c 4,5 -o collapse -i - \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\ttranscript_ids\tgene_name"} {print $0}' \
    | python sort_columns.py \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-eiee-genes-ostrander-v1.bed.gz
tabix -p bed grch37-eiee-genes-ostrander-v1.bed.gz

bedtools complement -i grch37-eiee-genes-ostrander-v1.bed.gz -g $genome_loc \
    | gsort /dev/stdin $genome \
    | sed '1d' \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > grch37-eiee-genes-ostrander-v1.complement.bed.gz
tabix -p bed grch37-eiee-genes-ostrander-v1.complement.bed.gz

#cleanup
rm eiee_genes.tsv
rm unflattened_grch37-eiee-genes-ostrander-v1.bed
rm $genome_loc
rm 41525_2018_61_MOESM1_ESM.xlsx
rm pyscript.py
rm parse_gene.py
rm sort_columns.py
rm coding_gene_file.bed
