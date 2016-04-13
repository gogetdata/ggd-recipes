#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/MIG.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-mig/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-mig/

baseurl=http://bcbio_nextgen.s3.amazonaws.com/MIG.zip
mkdir -p prioritization
cd prioritization
wget -c -O MIG.zip $baseurl
unzip MIG.zip
