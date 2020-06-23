#!/bin/sh
set -eo pipefail -o nounset

## Get the phastcons bigwig file
wget --quiet --no-check-certificate --output-document hg38-phastcons-ucsc-v1.bw http://hgdownload.soe.ucsc.edu/goldenPath/hg38/phastCons100way/hg38.phastCons100way.bw

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Convert bigwig to bedgraph 
bigWigToBedGraph hg38-phastcons-ucsc-v1.bw  /dev/stdout \
    | awk -v OFS="\t" 'BEGIN {print "#PhastCons info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=compGeno&hgta_track=cons100way&hgta_table=phastCons100way&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tscore"} {print $1,$2,$3,$4}' \
    | gsort /dev/stdin  $genome \
    | bgzip -c > hg38-phastcons-ucsc-v1.bedGraph.gz

tabix hg38-phastcons-ucsc-v1.bedGraph.gz

