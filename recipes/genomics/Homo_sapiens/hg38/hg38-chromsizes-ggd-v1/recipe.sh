#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
mv hg38.genome hg38-chromsizes-ggd-v1.txt