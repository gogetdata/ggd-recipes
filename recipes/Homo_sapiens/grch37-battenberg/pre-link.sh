#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/battenberg.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-battenberg/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-battenberg/

proburl=https://github.com/cancerit/cgpBattenberg/raw/dev/perl/share/battenberg/probloci.txt.gz
impute_info=battenberg/impute/impute_info.txt
mkdir -p battenberg
[[ -f $impute_info ]] || download_generate_bberg_ref_files.pl -c -o `pwd`/battenberg
# Change references to point to final directory
sed -i 's/txtmp\///g' $impute_info

wget --no-check-certificate -c -O battenberg/probloci.txt.gz $proburl
gunzip battenberg/probloci.txt.gz
