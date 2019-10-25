#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
mv GRCh38.genome grch38-chromsizes-ggd-v1.txt