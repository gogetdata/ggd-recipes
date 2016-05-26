#!/bin/bash
set -eo pipefail -o nounset
wget --quiet --no-check-certificate http://hgdownload.cse.ucsc.edu/goldenpath/hg19/phastCons100way/hg19.100way.phastCons.bw
