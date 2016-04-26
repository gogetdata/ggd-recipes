#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/clinvar.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

baseurl=ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/archive/2015
version=20150330
mkdir -p variation
wget --quiet -c -O variation/clinvar-orig.vcf.gz $baseurl/clinvar_$version.vcf.gz
gzip -dc variation/clinvar-orig.vcf.gz | awk 'BEGIN{FS=OFS="\t"}($1 ~ /^#/) { print } ($1 == "MT"){$1="M"} ($1 !~ /^#/) { print "chr"$0 }' | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg38/hg38.genome | bgzip -c > variation/clinvar.vcf.gz

tabix -f -p vcf variation/clinvar.vcf.gz
rm variation/clinvar-orig.vcf.gz

