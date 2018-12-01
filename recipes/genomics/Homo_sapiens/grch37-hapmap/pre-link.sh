#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/hapmap.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=ftp://gsapubftp-anonymous:none@ftp.broadinstitute.org/bundle/2.8/b37/hapmap_3.3.b37.vcf.gz
mkdir -p variation
cd variation
wget --quiet -O - $baseurl | gunzip -c | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome | bgzip -c > hapmap_3.3.vcf.gz
tabix -f -p vcf hapmap_3.3.vcf.gz

