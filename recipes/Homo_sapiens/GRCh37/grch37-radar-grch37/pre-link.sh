#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/RADAR.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/

url=http://www.stanford.edu/~gokulr/database/Human_AG_all_hg19_v2.txt
mkdir -p editing
cd editing
remap_url=http://raw.githubusercontent.com/dpryan79/ChromosomeMappings/master/GRCh37_UCSC2ensembl.txt
wget --no-check-certificate -qO- $remap_url | awk '{if($1!=$2) print "s/^"$1"/"$2"/g"}' > remap.sed
wget --no-check-certificate -qO- $url | sed -f remap.sed | awk 'BEGIN{OFS="\t"} {print $1,$2,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' | sed "s/position  position/start  end/" > RADAR-GRCh37.bed
rm remap.sed
cd ../

