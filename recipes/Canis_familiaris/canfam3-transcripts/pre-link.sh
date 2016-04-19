#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/canFam3/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Canis_familiaris/canFam3/ && cd $PREFIX/share/ggd/Canis_familiaris/canFam3/

baseurl=https://s3.amazonaws.com/biodata/annotation/canFam3-rnaseq-2014-07-20.tar.xz
wget -c -N $baseurl
xz -dc *-rnaseq-*.tar.xz | tar -xpf -
mv */rnaseq-* rnaseq

