#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/MIG.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=http://bcbio_nextgen.s3.amazonaws.com/MIG.zip
mkdir -p prioritization
cd prioritization
wget --quiet -c -O MIG.zip $baseurl
unzip MIG.zip
rm MIG.zip
gsort MIG.bed https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome | bgzip -c > MIG.bed.gz
tabix MIG.bed.gz
rm MIG.bed
