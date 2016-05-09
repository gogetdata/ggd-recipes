#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/hisat2.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://s3.amazonaws.com/biodata/genomes/hg38-hisat2-12-07-2015.tar.xz
wget -qO- $url > hg38-hisat2-tar.xz
tar xJvf hg38-hisat2-tar.xz
rm hg38-hisat2-tar.xz

