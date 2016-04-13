#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/mills_indels.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-mills_indels/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-mills_indels/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz
mkdir -p variation
cd variation
wget -O - $baseurl | gunzip -c | bgzip -c > Mills_and_1000G_gold_standard.indels.vcf.gz
tabix -f -p vcf Mills_and_1000G_gold_standard.indels.vcf.gz
