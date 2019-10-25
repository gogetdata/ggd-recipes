#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
mv hg19.genome hg19-chromsizes-ggd-v1.txt