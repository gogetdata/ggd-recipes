#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/cosmic.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=https://s3.amazonaws.com/biodata/variants/cosmic-v68-hg19.vcf.gz
mkdir -p variation
cd variation
wget --no-check-certificate -c -N $baseurl
wget --no-check-certificate -c -N $baseurl.tbi

