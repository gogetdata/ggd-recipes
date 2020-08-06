#!/bin/sh
set -eo pipefail -o nounset
wget --quiet ftp://ftp.ensembl.org/pub/assembly_mapping/homo_sapiens/GRCh38_to_GRCh37.chain.gz 
