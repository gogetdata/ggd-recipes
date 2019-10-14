#!/bin/sh
set -eo pipefail -o nounset


wget --quiet -O blekhman_ad.tsv https://raw.githubusercontent.com/macarthur-lab/gene_lists/master/lists/blekhman_ad.tsv

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

grch37_gtf="$(ggd get-files grch37-gtf-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-gtf-ensembl-v1.gtf.gz')"

## Get CDS regions from gtf file. Change start coordinate from 1 based to 0 based and create bed file
zless $grch37_gtf \
    | awk 'BEGIN { OFS="\t"} {if ( $3 == "CDS" || $3 == "stop_codon" ) print $0}' \
    | awk 'BEGIN { OFS="\t"} {$4=$4-1; print $0}' \
    | cut -f 1,4,5,12,16 \
    | sed 's/\"//g' \
    | sed 's/;//g' \
    | sed 's/ /\t/g' > coding_gene_file.bed

# matches gene names to bed coordinates
#python parse_genes.py blekhman_ad.tsv coding_gene_file.bed unflattened_ad_genes.bed  

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
python parse_gene.py blekhman_ad.tsv coding_gene_file.bed unflattened_ad_genes.bed  

## Merge and sort ad genes with coordinates
gsort unflattened_ad_genes.bed $genome \
    | bedtools merge -i - -c 4,5 -o collapse  \
    | awk 'BEGIN { print "#chrom\tstart\tend\ttranscript_ids\tgenes" } {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch37-autosomal-dominant-genes-blekhman-v1.bed.gz 
tabix grch37-autosomal-dominant-genes-blekhman-v1.bed.gz 

wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get ad gene complement coordinates 
bedtools complement -i grch37-autosomal-dominant-genes-blekhman-v1.bed.gz -g GRCh37.genome \
    | gsort /dev/stdin $genome \
    | sed '1d' /dev/stdin \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz 
tabix grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz 


rm GRCh37.genome
rm blekhman_ad.tsv
rm coding_gene_file.bed
rm unflattened_ad_genes.bed
rm parse_gene.py


