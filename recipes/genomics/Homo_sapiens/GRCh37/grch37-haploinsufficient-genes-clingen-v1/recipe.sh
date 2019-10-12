#!/bin/sh
set -eo pipefail -o nounset
#!/bin/bash

set -euo pipefail

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget -q $genome
genome_loc="GRCh37.genome"

grch37_gtf="$(ggd get-files grch37-gtf-ensembl-v1 -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-gtf-ensembl-v1.gtf.gz')"
zgrep 'protein_coding\tstop_codon\|protein_coding\tCDS' $grch37_gtf \
    | grep "^1\|^2\|^3\|^4\|^5\|^6\|^7\|^8\|^9\|^10\|^11\|^12\|^13\|^14\|^15\|^16\|^17\|^18\|^19\|^20\|^21\|^22\|^X\|^Y" \
    | awk '{$4=$4-1; print $0}' OFS='\t' \
    | cut -f 1,4,5,12,16 \
    | sed 's/\"//g' \
    | sed 's/;//g' > Homo_sapiens37.bed

# ClinGen haploinsufficient set from MacArthur lab
wget -q https://raw.githubusercontent.com/macarthur-lab/gene_lists/master/lists/clingen_level3_genes_2015_02_27.tsv

awk 'FNR==NR{genes[$1]; next} {for (gene in genes) if (gene == $5) print $0, genes[gene]}' FS='\t' OFS='\t' \
    clingen_level3_genes_2015_02_27.tsv Homo_sapiens37.bed \
    | gsort /dev/stdin $genome_loc \
    | cut -f -5 > unflattened_clingen_grch37-haploinsufficient-genes-clingen-v1.bed

# creates flattened representation of protein-coding exome covering AD genes
bedtools merge -c 4,5 -o collapse -i unflattened_clingen_grch37-haploinsufficient-genes-clingen-v1.bed \
    | gsort /dev/stdin $genome_loc \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tgene-id\tgene-name"} {print $0}' \
    | bgzip -c > grch37-haploinsufficient-genes-clingen-v1.bed.gz
tabix -p bed grch37-haploinsufficient-genes-clingen-v1.bed.gz

bedtools complement -i grch37-haploinsufficient-genes-clingen-v1.bed.gz -g $genome_loc \
    | gsort /dev/stdin $genome_loc \
    | sed '1d' \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz
tabix -f grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz

#cleanup
rm clingen_level3_genes_2015_02_27.tsv
rm Homo_sapiens37.bed
rm unflattened_clingen_grch37-haploinsufficient-genes-clingen-v1.bed
rm $genome_loc
