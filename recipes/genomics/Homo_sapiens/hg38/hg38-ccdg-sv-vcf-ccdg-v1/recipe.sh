#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
set -e
wget --quiet https://github.com/hall-lab/sv_paper_042020/raw/master/Supplementary_File_1.zip
unzip Supplementary_File_1.zip

#sort and tabix
gsort Build38.public.v2.vcf.gz https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome | bgzip -c > Build38.public.v2.sorted.vcf.gz
tabix Build38.public.v2.sorted.vcf.gz

#clean up
rm Build38.public.v2.vcf.gz
rm Supplementary_File_1.zip
rm Build38.public.v2.bedpe.gz

