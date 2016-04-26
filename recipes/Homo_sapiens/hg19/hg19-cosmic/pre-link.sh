#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/cosmic.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=https://s3.amazonaws.com/biodata/variants/cosmic-v68-hg19.vcf.gz
mkdir -p variation
cd variation
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
wget --quiet -O - --no-check-certificate -c $baseurl | gsort /dev/stdin $genome | bgzip -c > cosmic-v68-hg19.vcf.gz
tabix cosmic-v68-hg19.vcf.gz
