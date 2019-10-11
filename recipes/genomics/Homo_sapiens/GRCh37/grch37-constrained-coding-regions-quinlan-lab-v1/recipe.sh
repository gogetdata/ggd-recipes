#!/bin/sh
set -eo pipefail -o nounset
curl -sSLO https://s3.us-east-2.amazonaws.com/ccrs/ccrs/ccrs.autosomes.v2.20180420.bed.gz
tabix --csi ccrs.autosomes.v2.20180420.bed.gz

mv ccrs.autosomes.v2.20180420.bed.gz grch37-constrained-coding-regions-quinlan-lab-v1.bed.gz
mv ccrs.autosomes.v2.20180420.bed.gz.csi grch37-constrained-coding-regions-quinlan-lab-v1.bed.gz.csi
