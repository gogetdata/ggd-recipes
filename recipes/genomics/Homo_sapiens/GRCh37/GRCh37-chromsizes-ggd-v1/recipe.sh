#!/bin/sh
set -eo pipefail -o nounset
## Get the ggd genome file
wget --quiet https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
mv GRCh37.genome GRCh37-chromsizes.txt