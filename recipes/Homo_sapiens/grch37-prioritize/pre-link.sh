#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/prioritize.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-prioritize/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-prioritize/

baseurl=https://s3.amazonaws.com/biodata/coverage/prioritize/prioritize-cancer-GRCh37-20160215.tar.gz
outdir=coverage/prioritize
mkdir -p $outdir
cd $outdir
wget --no-check-certificate -c -O cancer.tar.gz $baseurl
tar -xzvpf cancer.tar.gz
