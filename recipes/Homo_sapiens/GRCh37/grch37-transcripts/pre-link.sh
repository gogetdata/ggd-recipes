#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

baseurl=https://s3.amazonaws.com/biodata/annotation/GRCh37-rnaseq-2015-12-01.tar.xz
wget -c -N $baseurl
xz -dc *-rnaseq-*.tar.xz | tar -xpf -
mv */rnaseq-* rnaseq

