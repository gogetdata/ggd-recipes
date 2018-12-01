#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/1000g_omni_snps.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/b37/1000G_omni2.5.b37.vcf.gz
mkdir -p variation
cd variation
wget --quiet -c -O - $baseurl | gunzip -c | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome | bgzip -c > 1000G_omni2.5.vcf.gz
tabix -f -p vcf  1000G_omni2.5.vcf.gz

