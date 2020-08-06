#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD in bgzipped VCF format
wget --quiet https://ftp.ncbi.nlm.nih.gov/pub/dbVar/data/Homo_sapiens/by_study/vcf/nstd166.GRCh38.variant_call.vcf.gz

# Get the chromosome mapping file and ref for grch38
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
chr_mapping=$(ggd get-files grch38-chrom-mapping-refseq2ensembl-ncbi-v1 --pattern "*.txt")
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
chr_mapping2=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

#sort and tabix and resort and retabix
gsort --chromosomemappings $chr_mapping 2> tmp.err\
    nstd166.GRCh38.variant_call.vcf.gz $genome \
    | gsort --chromosomemappings $chr_mapping2 /dev/stdin $genome2 \
    | bgzip -c > gnomad_v2_sv_sorted.hg38.sites.vcf.gz

grep -v "WARNING: could not find mapping for chromosome" tmp.err
tabix gnomad_v2_sv_sorted.hg38.sites.vcf.gz

#clean up
rm nstd166.GRCh38.variant_call.vcf.gz
rm tmp.err
