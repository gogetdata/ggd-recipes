#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/canFam3/dbsnp.yaml

mkdir -p $PREFIX/share/ggd/Canis_familiaris/canFam3/ && cd $PREFIX/share/ggd/Canis_familiaris/canFam3/

baseurl=https://s3.amazonaws.com/biodata/variants/canFam3-dbSNP-2014-05-10.vcf.gz
mkdir -p variation
cd variation
wget --quiet -c -N $baseurl
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/canFam3/canFam3.genome
gsort canFam3-dbSNP-2014-05-10.vcf.gz canFam3.genome | bgzip -c > t.vcf.gz
mv t.vcf.gz canFam3-dbSNP-2014-05-10.vcf.gz
tabix canFam3-dbSNP-2014-05-10.vcf.gz

