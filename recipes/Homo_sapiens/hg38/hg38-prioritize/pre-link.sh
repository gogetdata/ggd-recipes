#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/prioritize.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

baseurl=https://s3.amazonaws.com/biodata/coverage/prioritize/prioritize-cancer-hg38-20160215.tar.gz
outdir=coverage/prioritize
mkdir -p $outdir
cd $outdir
wget --no-check-certificate -c -O cancer.tar.gz $baseurl
tar -xzvpf cancer.tar.gz
rm -rf cancer.tar.gz
