#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (grch37) in bgzipped VCF format
wget --quiet https://storage.googleapis.com/gnomad-public/papers/2019-sv/gnomad_v2.1_sv.sites.vcf.gz 

# Get the chromosome mapping file and ref
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")


#sort and tabix
gsort --chromosomemappings $chr_mapping gnomad_v2.1_sv.sites.vcf.gz $genome | bgzip -c > gnomad_v2_sv_sorted.sites.vcf.gz
tabix gnomad_v2_sv_sorted.sites.vcf.gz

#clean up
rm gnomad_v2.1_sv.sites.vcf.gz
