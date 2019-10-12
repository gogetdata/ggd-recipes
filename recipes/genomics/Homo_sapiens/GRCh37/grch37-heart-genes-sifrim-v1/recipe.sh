#!/bin/sh
set -eo pipefail -o nounset
#!/bin/bash

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget -q $genome
genome_loc="GRCh37.genome"

#Manually curated list of congenital heart disease (CHD) genes from Sifrim et al.: www.nature.com/articles/ng.3627
wget -q https://media.nature.com/original/nature-assets/ng/journal/v48/n9/extref/ng.3627-S13.xlsx

#######################################################################################################
#nested python to convert from xls
cat << EOF > pyscript.py
from __future__ import print_function
import sys
import pyexcel as pe

book = pe.get_book(file_name=sys.argv[1])

genelist = open('grch37-heart-genes-sifrim-v1.tsv', 'w')

sheet = book['Suppl Table 20']
for i, record in enumerate(sheet):
    if i == 0:
        continue
    print(record[0], file=genelist)
genelist.close()
EOF

python pyscript.py ng.3627-S13.xlsx
#######################################################################################################

grch37_gtf="$(ggd get-files grch37-gtf-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-gtf-ensembl-v1.gtf.gz')"
#only grabs protein coding sequence, CDS or stop_codon (separate from CDS for some reason) | then turns 1-based GFF format into 0-based half-open, BED format | cuts out necessary columns, sorts by gene
zgrep 'protein_coding\tstop_codon\|protein_coding\tCDS' $grch37_gtf \
    | awk '{$4=$4-1; print $0}' OFS='\t' \
    | cut -f 1,4,5,12,16 \
    | sed 's/\"//g' \
    | sed 's/;//g' > Homo_sapiens37.bed
    
# matches gene names to bed coordinates
awk 'FNR==NR{genes[$1]; next} {for (gene in genes) if (gene == $5) print $0, genes[gene]}' \
        FS='\t' \
        OFS='\t' grch37-heart-genes-sifrim-v1.tsv Homo_sapiens37.bed \
    | gsort /dev/stdin $genome_loc \
    | cut -f -5 > unflattened_grch37-heart-genes-sifrim-v1.bed

# creates flattened representation of protein-coding exome covering AD genes
bedtools merge -c 4,5 -o collapse -i unflattened_grch37-heart-genes-sifrim-v1.bed \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tgene-id\tgene-name"} {print $0}' \
    | gsort /dev/stdin $genome_loc \
    | bgzip -c > grch37-heart-genes-sifrim-v1.bed.gz
tabix grch37-heart-genes-sifrim-v1.bed.gz

# bedtools complement so we can use the EXCLUDE option
bedtools complement -i grch37-heart-genes-sifrim-v1.bed.gz -g $genome_loc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $0}' \
    | gsort /dev/stdin $genome_loc \
    | bgzip -c > grch37-heart-genes-sifrim-v1.complement.bed.gz
tabix -f grch37-heart-genes-sifrim-v1.complement.bed.gz

rm GRCh37.genome
rm Homo_sapiens37.bed
rm grch37-heart-genes-sifrim-v1.tsv
rm unflattened_grch37-heart-genes-sifrim-v1.bed
rm ng.3627-S13.xlsx
rm pyscript.py
