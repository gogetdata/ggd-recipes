#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-transcripts/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/hg19-transcripts/

baseurl=https://s3.amazonaws.com/biodata/annotation/hg19-rnaseq-2014-07-17.tar.xz
wget -c -N $baseurl
xz -dc *-rnaseq-*.tar.xz | tar -xpf -
mv */rnaseq-* rnaseq
