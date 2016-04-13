#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/mills_indels.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-mills_indels/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-mills_indels/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf.gz
mkdir -p variation
cd variation
wget -O - $baseurl | gunzip -c | bgzip -c > Mills_and_1000G_gold_standard.indels.vcf.gz
tabix -f -p vcf Mills_and_1000G_gold_standard.indels.vcf.gz
