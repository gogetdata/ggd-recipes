#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
wget --quiet https://github.com/hall-lab/sv_paper_042020/raw/master/Supplementary_File_2.zip
unzip Supplementary_File_2.zip

## Get the chromosome mapping file and ref
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
chr_mapping=$(ggd get-files hg19-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

#sort and tabix
gsort --chromosomemappings $chr_mapping Build37.public.v2.bedpe.gz $genome |
    bgzip -c > hg19.public.sorted.v2.bedpe.gz
tabix -p bed hg19.public.sorted.v2.bedpe.gz

#clean up
rm Build37.public.v2.vcf.gz
rm Build37.public.v2.bedpe.gz
rm Supplementary_File_2.zip
