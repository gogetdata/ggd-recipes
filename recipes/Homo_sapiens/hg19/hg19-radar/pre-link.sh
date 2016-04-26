#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/RADAR.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

url=http://www.stanford.edu/~gokulr/database/Human_AG_all_hg19_v2.txt
mkdir -p editing
cd editing
wget --no-check-certificate -qO- $url | awk 'BEGIN{OFS="\t"}(NR ==1){printf "#"} {print $1,$2,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' | sed "s/position  position/start  end/" \
	| gsort /dev/stdin https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome | bgzip -c > RADAR-hg19.bed.gz
tabix RADAR-hg19.bed.gz

