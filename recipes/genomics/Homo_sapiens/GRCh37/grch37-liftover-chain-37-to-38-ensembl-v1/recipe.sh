#!/bin/sh
set -eo pipefail -o nounset
wget --quiet ftp://ftp.ensembl.org/pub/assembly_mapping/homo_sapiens/GRCh37_to_GRCh38.chain.gz 
