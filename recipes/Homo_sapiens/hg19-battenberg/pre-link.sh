#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/battenberg.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-battenberg/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-battenberg/

proburl=https://github.com/cancerit/cgpBattenberg/raw/dev/perl/share/battenberg/probloci.txt.gz
impute_info=battenberg/impute/impute_info.txt
mkdir -p battenberg
[[ -f $impute_info ]] || download_generate_bberg_ref_files.pl -c -o `pwd`/battenberg
# Change references to point to final directory
sed -i 's/txtmp\///g' $impute_info

wget --no-check-certificate -c -O battenberg/probloci.txt.gz $proburl
gunzip battenberg/probloci.txt.gz

# Convert chromosomes to hg19 names
sed -i "s/^\([0-9]\+\)\t/chr\1\t/g" battenberg/probloci.txt
sed -i "s/^X/chrX/g" battenberg/probloci.txt
sed -i "s/^\([0-9]\+\)\t/chr\1\t/g" $impute_info
sed -i "s/^X/chrX/g" $impute_info
sed -i "s/^\([0-9]\+\)\t/chr\1\t/g" battenberg/1000genomesloci/1000genomesloci2012_chr*
sed -i "s/^X/chrX/g" battenberg/1000genomesloci/1000genomesloci2012_chr23.txt
