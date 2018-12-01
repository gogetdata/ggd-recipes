#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/1000g_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://s3.amazonaws.com/biodata/hg38_bundle
base=1000G_phase1.snps.high_confidence.b38.primary_assembly
new=1000G_phase1.snps.high_confidence
mkdir -p variation
cd variation
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg38/hg38.genome
wget --quiet -c -O - $url/${base}.vcf.gz | gsort /dev/stdin $genome \
	| bgzip -c > ${new}.vcf.gz
tabix ${new}.vcf.gz
