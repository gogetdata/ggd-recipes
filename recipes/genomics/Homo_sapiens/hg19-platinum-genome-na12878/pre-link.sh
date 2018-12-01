#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/platinum-genome-NA12878.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

dir=validation/platinum-genome-NA12878
mkdir -p $dir
wget --quiet --no-check-certificate -c -O $dir/truth_small_variants.vcf.gz ftp://platgene_ro:@ussd-ftp.illumina.com/hg19/8.0.1/NA12878/NA12878.vcf.gz
wget --quiet --no-check-certificate -c -O - ftp://platgene_ro:@ussd-ftp.illumina.com/hg19/8.0.1/NA12878/ConfidentRegions.bed.gz | gunzip -c > $dir/truth_regions.bed

cd $dir/
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
mkdir tmp
gsort truth_small_variants.vcf.gz hg19.genome | bgzip -c > tmp/truth_small_variants.vcf.gz
gsort truth_regions.bed hg19.genome | bgzip -c > tmp/truth_regions.bed.gz
mv tmp/* .
rm -r tmp
tabix truth_small_variants.vcf.gz
tabix truth_regions.bed.gz
rm truth_regions.bed hg19.genome
