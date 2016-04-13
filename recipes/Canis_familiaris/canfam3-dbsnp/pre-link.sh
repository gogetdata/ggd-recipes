#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/canFam3/dbsnp.yaml

mkdir -p $PREFIX/share/ggd/Canis_familiaris/canFam3/canfam3-dbsnp/ && cd $PREFIX/share/ggd/Canis_familiaris/canFam3/canfam3-dbsnp/

baseurl=https://s3.amazonaws.com/biodata/variants/canFam3-dbSNP-2014-05-10.vcf.gz
mkdir -p variation
cd variation
wget -c -N $baseurl
wget -c -N $baseurl.tbi
