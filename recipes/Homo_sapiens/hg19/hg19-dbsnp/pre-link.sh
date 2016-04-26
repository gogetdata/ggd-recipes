#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/dbsnp.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/hg19/dbsnp_138.hg19.vcf.gz
mkdir -p variation
cd variation
wget --quiet -O - $baseurl | gunzip -c | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome | bgzip -c > dbsnp_138.vcf.gz
tabix -f -p vcf dbsnp_138.vcf.gz

