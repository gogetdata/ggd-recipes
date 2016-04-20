#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/giab-NA12878-remap.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

dir=validation/giab-NA12878-remap
mkdir -p $dir
wget --quiet --no-check-certificate -c -O $dir/truth_small_variants.vcf.gz https://biodata.s3.amazonaws.com/giab_hg38_remap/GiaB_v2_19-38_remap.vcf.gz
wget --quiet --no-check-certificate -c -O $dir/truth_small_variants.vcf.gz.tbi https://biodata.s3.amazonaws.com/giab_hg38_remap/GiaB_v2_19-38_remap.vcf.gz.tbi
wget --quiet --no-check-certificate -c -O - https://biodata.s3.amazonaws.com/giab_hg38_remap/GiaB_v2_19-38_remap-regions.bed | grep -v ^chrM > $dir/truth_regions.bed

