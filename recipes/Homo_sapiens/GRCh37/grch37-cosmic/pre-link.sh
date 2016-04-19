#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/cosmic.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=https://s3.amazonaws.com/biodata/variants/cosmic-v68-GRCh37.vcf.gz
mkdir -p variation
cd variation
wget --no-check-certificate -c -N $baseurl
wget --no-check-certificate -c -N $baseurl.tbi

