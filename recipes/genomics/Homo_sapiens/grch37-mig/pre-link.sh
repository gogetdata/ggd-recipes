#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/MIG.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=http://bcbio_nextgen.s3.amazonaws.com/MIG.zip
mkdir -p prioritization
cd prioritization
wget --quiet -c -O MIG.zip $baseurl
unzip MIG.zip
rm MIG.zip
file=MIG.bed

sed 's/^chr//g' $file | gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome | bgzip -c > $file.gz
tabix $file.gz
rm $file
