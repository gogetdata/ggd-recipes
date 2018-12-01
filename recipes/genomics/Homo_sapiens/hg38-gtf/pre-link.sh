#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/gtf.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=ftp://ftp.ensembl.org/pub/release-78/gtf/homo_sapiens/Homo_sapiens.GRCh38.78.gtf.gz
mkdir -p rnaseq
remap_url=http://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh38_ensembl2UCSC.txt
wget --quiet --no-check-certificate -qO- $remap_url | awk '{if($1!=$2) print "s/^"$1"/"$2"/g"}' > remap.sed
wget --quiet --no-check-certificate -qO- $url | gunzip | sed -f remap.sed | grep -v "*_*_alt" > rnaseq/hg38.gtf
rm remap.sed

