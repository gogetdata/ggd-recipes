#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38/RADAR.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38/

url=https://biodata.s3.amazonaws.com/annotation/RADAR-hg38.bed.gz
mkdir -p editing
cd editing
  wget --no-check-certificate -qO- $url > RADAR-hg38.bed.gz
   cd ../

