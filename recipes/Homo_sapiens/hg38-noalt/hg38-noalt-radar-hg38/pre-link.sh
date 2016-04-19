#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg38-noalt/RADAR.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/ && cd $PREFIX/share/ggd/Homo_sapiens/hg38-noalt/

url=https://biodata.s3.amazonaws.com/annotation/RADAR-hg38.bed.gz
mkdir -p editing
cd editing
  wget -qO- $url > RADAR-hg38.bed.gz
   cd ../

