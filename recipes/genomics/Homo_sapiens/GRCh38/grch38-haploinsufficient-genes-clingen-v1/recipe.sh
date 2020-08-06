#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

grch38_gtf="$(ggd get-files grch38-gene-features-ensembl-v1 -p 'grch38-gene-features-ensembl-v1.gtf.gz')"

# ClinGen haploinsufficient set from MacArthur lab
wget -q https://raw.githubusercontent.com/macarthur-lab/gene_lists/master/lists/clingen_level3_genes_2015_02_27.tsv

cat << EOF > parse_gtf_by_gene.py
"""
Get a list of genome coordinates for a list of haploinsufficient genes
"""
import sys 
import io
import gzip

gtf_file = sys.argv[1] ## A gtf file with CDS features
haploinsufficient_gene_file = sys.argv[2] ## A single column tsv file for haploinsufficient genes
outfile = sys.argv[3] ## File to write to

## Get a set of gene symbols
haploinsufficient_gene_set = {}
with io.open(haploinsufficient_gene_file, "rt", encoding = "utf-8") as haploinsufficient:
    haploinsufficient_gene_set = set(x.strip() for x in haploinsufficient)
    
## Parse the gtf file
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
haploinsufficient_gene_dict = dict()
header = []
for line in fh:
    if line[0] == "#":
        header = line.strip().split("\t")
        continue
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    ## If the current gene is in the haploinsufficient gene set
    if line_dict["gene_name"] in haploinsufficient_gene_set:
        
        if line_dict["gene_name"] not in haploinsufficient_gene_dict:
            haploinsufficient_gene_dict[line_dict["gene_name"]] = [] 
        ## If CDS or stop_codon feature, add feature info to haploinsufficient_gene_dict
        if line_dict["feature"] == "CDS" or line_dict["feature"] == "stop_codon":
            ## Change 1 based start to zero based start
            haploinsufficient_gene_dict[line_dict["gene_name"]].append([str(line_dict["#chrom"]), 
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
    for gene, coor in haploinsufficient_gene_dict.items():
        for line in coor:
            o.write("\t".join(line) + "\n")
EOF


python parse_gtf_by_gene.py $grch38_gtf clingen_level3_genes_2015_02_27.tsv unflattened_haploinsufficient_genes.bed  



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



## Merge and sort ad genes with coordinates
gsort unflattened_haploinsufficient_genes.bed $genome \
    | bedtools merge -i - -c 4,5,6,7,8 -o collapse \
    | awk -v OFS="\t" 'BEGIN { print "#chrom\tstart\tend\tstrand\tgene_ids\tgene_symbols\ttranscript_ids\tgene_biotypes" } {print $0}' \
    | python sort_columns.py \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-haploinsufficient-genes-clingen-v1.bed.gz 
tabix grch38-haploinsufficient-genes-clingen-v1.bed.gz

wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get ad gene complement coordinates 
sed "1d" GRCh38.genome \
    | bedtools complement -i <(zgrep -v "#" grch38-haploinsufficient-genes-clingen-v1.bed.gz) -g /dev/stdin \
    | gsort /dev/stdin $genome \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > grch38-haploinsufficient-genes-clingen-v1.compliment.bed.gz 
tabix grch38-haploinsufficient-genes-clingen-v1.compliment.bed.gz 


rm GRCh38.genome
rm clingen_level3_genes_2015_02_27.tsv 
rm unflattened_haploinsufficient_genes.bed
rm parse_gtf_by_gene.py
rm sort_columns.py

