#!/bin/sh
set -eo pipefail -o nounset
#download SVs from gnomAD (HG19) in bgzipped VCF format
wget --quiet http://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/hg38ToHg19.over.chain.gz 
