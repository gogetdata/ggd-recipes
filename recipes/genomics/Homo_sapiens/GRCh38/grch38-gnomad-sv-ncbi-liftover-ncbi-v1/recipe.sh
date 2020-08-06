#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD in bgzipped VCF format
wget --quiet https://ftp.ncbi.nlm.nih.gov/pub/dbVar/data/Homo_sapiens/by_study/vcf/nstd166.GRCh38.variant_call.vcf.gz

# Get the chromosome mapping file and ref for grch38
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
chr_mapping=$(ggd get-files grch38-chrom-mapping-refseq2ensembl-ncbi-v1 --pattern "*.txt")

#sort and tabix
gsort --chromosomemappings $chr_mapping \
    nstd166.GRCh38.variant_call.vcf.gz $genome 2> tmp.err\
    | bgzip -c \
    > gnomad_v2_sv_sorted.sites.vcf.gz 

grep -v "WARNING: could not find mapping for chromosome" tmp.err
tabix gnomad_v2_sv_sorted.sites.vcf.gz

#clean up
rm nstd166.GRCh38.variant_call.vcf.gz
rm tmp.err
