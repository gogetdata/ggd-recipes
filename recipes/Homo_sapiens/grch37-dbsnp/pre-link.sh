#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/dbsnp.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-dbsnp/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-dbsnp/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/b37/dbsnp_138.b37.vcf.gz
mkdir -p variation
cd variation
wget -O - $baseurl | gunzip -c | bgzip -c > dbsnp_138.vcf.gz
tabix -f -p vcf dbsnp_138.vcf.gz
