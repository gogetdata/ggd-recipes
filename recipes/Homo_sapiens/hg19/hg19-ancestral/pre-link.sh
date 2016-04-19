#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/ancestral.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=https://s3.amazonaws.com/bcbio_nextgen/human_ancestor.fa.gz
mkdir -p variation
cd variation
wget --no-check-certificate -c $baseurl
wget --no-check-certificate -c $baseurl.fai
wget --no-check-certificate -c $baseurl.gzi

