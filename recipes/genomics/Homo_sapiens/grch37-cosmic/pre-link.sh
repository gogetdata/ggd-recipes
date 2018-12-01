#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/cosmic.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=https://s3.amazonaws.com/biodata/variants/cosmic-v68-GRCh37.vcf.gz
mkdir -p variation
cd variation
wget --quiet -O - --no-check-certificate -c -N $baseurl \
	| gsort /dev/stdin/ https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome \
	| bgzip -c > cosmic-v68-GRCh37.vcf.gz

tabix cosmic-v68-GRCh37.vcf.gz
