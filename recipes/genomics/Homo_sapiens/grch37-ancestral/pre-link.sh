#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/ancestral.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=https://s3.amazonaws.com/bcbio_nextgen/human_ancestor.fa.gz
mkdir -p variation
cd variation
wget --quiet --no-check-certificate -c $baseurl
wget --quiet --no-check-certificate -c $baseurl.fai
wget --quiet --no-check-certificate -c $baseurl.gzi

