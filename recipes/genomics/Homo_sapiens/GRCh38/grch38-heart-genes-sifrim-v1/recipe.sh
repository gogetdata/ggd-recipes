#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
wget -q $genome

## Get a gtf file
grch38_gtf="$(ggd get-files grch38-gene-features-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh38' -p 'grch38-gene-features-ensembl-v1.gtf.gz')"

#Manually curated list of congenital heart disease (CHD) genes from Sifrim et al.: www.nature.com/articles/ng.3627
wget -q https://media.nature.com/original/nature-assets/ng/journal/v48/n9/extref/ng.3627-S13.xlsx

cat << EOF > pyscript.py
from __future__ import print_function
import sys
import pyexcel as pe

book = pe.get_book(file_name=sys.argv[1])

genelist = open('grch38-heart-genes-sifrim-v1.tsv', 'w')

sheet = book['Suppl Table 20']
for i, record in enumerate(sheet):
    if i == 0:
        continue
    print(record[0], file=genelist)
genelist.close()
EOF

python pyscript.py ng.3627-S13.xlsx


cat << EOF > parse_gtf_by_gene.py
"""
Get a list of genome coordinates for a list of heart genes
"""
import sys 
import io
import gzip
gtf_file = sys.argv[1] ## A gtf file with CDS features
heart_gene_file = sys.argv[2] ## A single column tsv file for heart genes
outfile = sys.argv[3] ## File to write to
## Get a set of gene symbols
heart_gene_set = {}
with io.open(heart_gene_file, "rt", encoding = "utf-8") as heart:
    heart_gene_set = set(x.strip() for x in heart)
    
## Parse the gtf file
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
heart_gene_dict = dict()
header = []
for line in fh:
    if line[0] == "#":
        header = line.strip().split("\t")
        continue
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    ## If the current gene is in the heart gene set
    if line_dict["gene_name"] in heart_gene_set:
        
        if line_dict["gene_name"] not in heart_gene_dict:
            heart_gene_dict[line_dict["gene_name"]] = [] 
        ## If CDS or stop_codon feature, add feature info to heart_gene_dict
        if line_dict["feature"] == "CDS" or line_dict["feature"] == "stop_codon":
            ## Change 1 based start to zero based start
            heart_gene_dict[line_dict["gene_name"]].append([str(line_dict["#chrom"]), 
                                                           str(int(line_dict["start"]) - 1),  
                                                           str(line_dict["end"]), 
                                                           str(line_dict["strand"]), 
                                                           str(line_dict["gene_id"]), 
                                                           str(line_dict["gene_name"]),
                                                           str(line_dict["transcript_id"]),
                                                           str(line_dict["gene_biotype"])
                                                          ])
fh.close()
## Write dict out
with open(outfile, "w") as o:
    for gene, coor in heart_gene_dict.items():
        for line in coor:
            o.write("\t".join(line) + "\n")
EOF

python parse_gtf_by_gene.py $grch38_gtf grch38-heart-genes-sifrim-v1.tsv unflattened_grch38-heart-genes-sifrim-v1.bed 

cat << EOF > sort_columns.py
"""
sort the transcript id column
sort and get a unique list of the gene column
""" 
import sys
for line in sys.stdin.readlines():
    line_list = line.strip().split("\t")
    ## Sort column 4 - 8 and get a uniqe list
    line_list[3] = ",".join(sorted(list(set(line_list[3].strip().split(",")))))
    line_list[4] = ",".join(sorted(list(set(line_list[4].strip().split(",")))))
    line_list[5] = ",".join(sorted(list(set(line_list[5].strip().split(",")))))
    line_list[6] = ",".join(sorted(list(set(line_list[6].strip().split(",")))))
    line_list[7] = ",".join(sorted(list(set(line_list[7].strip().split(",")))))
    ## Print to stdout
    print("\t".join(line_list))
EOF


# creates flattened representation of protein-coding exome covering AD genes
gsort unflattened_grch38-heart-genes-sifrim-v1.bed $genome \
    | bedtools merge -i - -c 4,5,6,7,8 -o collapse \
    | awk -v OFS="\t" 'BEGIN { print "#chrom\tstart\tend\tstrand\tgene_ids\tgene_symbols\ttranscript_ids\tgene_biotypes" } {print $0}' \
    | python sort_columns.py \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-heart-genes-sifrim-v1.bed.gz
tabix grch38-heart-genes-sifrim-v1.bed.gz

# bedtools complement so we can use the EXCLUDE option

sed "1d" GRCh38.genome \
    | bedtools complement -i <(zgrep -v "#" grch38-heart-genes-sifrim-v1.bed.gz) -g /dev/stdin \
    | gsort /dev/stdin $genome \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $0}' \
    | bgzip -c > grch38-heart-genes-sifrim-v1.complement.bed.gz
tabix -f grch38-heart-genes-sifrim-v1.complement.bed.gz

rm grch38-heart-genes-sifrim-v1.tsv
rm unflattened_grch38-heart-genes-sifrim-v1.bed
rm ng.3627-S13.xlsx
rm pyscript.py
rm sort_columns.py
rm parse_gtf_by_gene.py
rm GRCh38.genome
