#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/dream-syn4-crossmap.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

dir=validation/dream-syn4-crossmap
orig=synthetic_challenge_set4_tumour_25pctmasked_truth-crossmap-hg38
mkdir -p $dir
wget --quiet --no-check-certificate -c https://s3.amazonaws.com/bcbio_nextgen/dream/synthetic_challenge_set4_tumour_25pctmasked_truth-crossmap-hg38.tar.gz
tar -xzvpf ${orig}.tar.gz
cp $orig/${orig}.vcf.gz $dir/truth_small_variants.vcf.gz
cp $orig/${orig}.vcf.gz.tbi $dir/truth_small_variants.vcf.gz.tbi
cp $orig/${orig}_regions.bed $dir/truth_regions.bed
cp $orig/${orig}_sv_DEL.bed $dir/truth_DEL.bed 
cp $orig/${orig}_sv_DUP.bed $dir/truth_DUP.bed
cp $orig/${orig}_sv_INV.bed $dir/truth_INV.bed
rm -rf $orig
rm ${orig}.tar.gz
