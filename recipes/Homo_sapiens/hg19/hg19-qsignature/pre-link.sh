#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/qsignature.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=http://downloads.sourceforge.net/project/adamajava/qsignature.tar.bz2
mkdir -p variation
cd variation
wget -N -c $baseurl
tar -xjf qsignature.tar.bz2 qsignature_positions.txt
mv qsignature_positions.txt qsignature.vcf

