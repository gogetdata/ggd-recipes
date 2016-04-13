#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/platinum-genome-NA12878.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-platinum-genome-na12878/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-platinum-genome-na12878/

dir=validation/platinum-genome-NA12878
mkdir -p $dir
wget --no-check-certificate -c -O $dir/truth_small_variants.vcf.gz ftp://platgene_ro:@ussd-ftp.illumina.com/hg19/8.0.1/NA12878/NA12878.vcf.gz
wget --no-check-certificate -c -O $dir/truth_small_variants.vcf.gz.tbi ftp://platgene_ro:@ussd-ftp.illumina.com/hg19/8.0.1/NA12878/NA12878.vcf.gz.tbi
wget --no-check-certificate -c -O - ftp://platgene_ro:@ussd-ftp.illumina.com/hg19/8.0.1/NA12878/ConfidentRegions.bed.gz | gunzip -c > $dir/truth_regions.bed
