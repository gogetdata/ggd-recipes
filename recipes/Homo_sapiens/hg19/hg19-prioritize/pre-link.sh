#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/prioritize.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

baseurl=https://s3.amazonaws.com/biodata/coverage/prioritize/prioritize-cancer-hg19-20160215.tar.gz
outdir=coverage/prioritize
mkdir -p $outdir
cd $outdir
wget --no-check-certificate -c -O cancer.tar.gz $baseurl
tar -xzvpf cancer.tar.gz

