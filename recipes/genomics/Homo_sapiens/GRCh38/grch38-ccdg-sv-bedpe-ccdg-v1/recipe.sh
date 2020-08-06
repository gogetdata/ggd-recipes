#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
wget --quiet https://github.com/hall-lab/sv_paper_042020/raw/master/Supplementary_File_1.zip
unzip Supplementary_File_1.zip

## Get the chromosome mapping file and ref
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
chr_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

#sort and tabix
gsort --chromosomemappings $chr_mapping Build38.public.v2.bedpe.gz $genome |
    bgzip -c > grch38.public.sorted.v2.bedpe.gz
tabix -p bed grch38.public.sorted.v2.bedpe.gz

#clean up
rm Build38.public.v2.vcf.gz
rm Build38.public.v2.bedpe.gz
rm Supplementary_File_1.zip
