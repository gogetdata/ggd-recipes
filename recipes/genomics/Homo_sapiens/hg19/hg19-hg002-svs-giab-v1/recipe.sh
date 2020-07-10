#!/bin/sh
set -eo pipefail -o nounset
#get data
wget -q ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/AshkenazimTrio/HG002_NA24385_son/NIST_SV_v0.6/HG002_SVs_Tier1_v0.6.vcf.gz

#sort/index
genome="https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome"
chr_mapping=$(ggd get-files hg19-chrom-mapping-refseq2ucsc-ncbi-v1 --pattern "*.txt")

gsort --chromosomemappings $chr_mapping HG002_SVs_Tier1_v0.6.vcf.gz $genome | bgzip -c > HG002_SVs_Tier1_v0.6.sorted.vcf.gz
tabix HG002_SVs_Tier1_v0.6.sorted.vcf.gz

#cleanup
rm HG002_SVs_Tier1_v0.6.vcf.gz
