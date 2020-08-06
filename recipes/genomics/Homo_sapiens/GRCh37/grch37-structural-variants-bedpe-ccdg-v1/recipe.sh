#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
wget --quiet https://github.com/hall-lab/sv_paper_042020/raw/master/Supplementary_File_2.zip
unzip Supplementary_File_2.zip

#sort and tabix
gsort Build37.public.v2.bedpe.gz https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome | bgzip -c > Build37.public.v2.sorted.bedpe.gz
tabix -p bed Build37.public.v2.sorted.bedpe.gz

#clean up
rm Build37.public.v2.vcf.gz
rm Build37.public.v2.bedpe.gz
rm Supplementary_File_2.zip
