#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/mm10/transcripts.yaml

mkdir -p $PREFIX/share/ggd/Mus_musculus/mm10/ && cd $PREFIX/share/ggd/Mus_musculus/mm10/

baseurl=https://s3.amazonaws.com/biodata/annotation/mm10-rnaseq-2014-07-14.tar.xz
wget -c -N $baseurl
xz -dc *-rnaseq-*.tar.xz | tar -xpf -
mv */rnaseq-* rnaseq

