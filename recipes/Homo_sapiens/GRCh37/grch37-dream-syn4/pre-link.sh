#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/dream-syn4.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

dir=validation/dream-syn4
orig=synthetic_challenge_set4_tumour_25pctmasked_truth
mkdir -p $dir
wget --no-check-certificate -c https://s3.amazonaws.com/bcbio_nextgen/dream/synthetic_challenge_set4_tumour_25pctmasked_truth.tar.gz
tar -xzvpf ${orig}.tar.gz
cp ${orig}.vcf.gz $dir/truth_small_variants.vcf.gz
cp ${orig}.vcf.gz.tbi $dir/truth_small_variants.vcf.gz.tbi
cp ${orig}_regions.bed $dir/truth_regions.bed
cp ${orig}_sv_DEL.bed $dir/truth_DEL.bed 
cp ${orig}_sv_DUP.bed $dir/truth_DUP.bed
cp ${orig}_sv_INV.bed $dir/truth_INV.bed

