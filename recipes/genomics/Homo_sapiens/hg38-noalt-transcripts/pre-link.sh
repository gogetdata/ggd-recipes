#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

baseurl=https://s3.amazonaws.com/biodata/annotation/hg38-noalt-rnaseq-2015-11-22.tar.xz
wget -c -N $baseurl
xz -dc *-rnaseq-*.tar.xz | tar -xpf -
rm hg38-noalt-rnaseq-2015-11-22.tar.xz
mv */rnaseq-* rnaseq

