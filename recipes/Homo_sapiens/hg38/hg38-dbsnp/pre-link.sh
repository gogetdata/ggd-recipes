#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/dbsnp.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

version=144
org=human_9606_b${version}_GRCh38p2
release=20150603
url=ftp://ftp.ncbi.nih.gov/snp/organisms/$org/VCF/All_$release.vcf.gz
mkdir -p variation
wget --quiet -c -O variation/dbsnp-$version-orig.vcf.gz $url
[[ -f variation/dbsnp-$version.vcf.gz ]] || zcat variation/dbsnp-$version-orig.vcf.gz | sed "s/^\([0-9]\+\)\t/chr\1\t/g" | sed "s/^MT/chrM/g" | sed "s/^X/chrX/g" | sed "s/^Y/chrY/g" | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg38/hg38.genome | bgzip -c > variation/dbsnp-$version.vcf.gz
tabix -f -p vcf variation/dbsnp-$version.vcf.gz

