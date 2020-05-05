#!/bin/sh
set -eo pipefail -o nounset


## Get the phastcon bigwig file
wget --quiet --no-check-certificate --output-document hg19-phastcons-ucsc-v1.bw http://hgdownload.cse.ucsc.edu/goldenpath/hg19/phastCons100way/hg19.100way.phastCons.bw

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome

## Convert bigwig to bedgraph 
bigWigToBedGraph hg19-phastcons-ucsc-v1.bw  /dev/stdout \
    | awk -v OFS="\t" 'BEGIN {print "#PhastCons info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=compGeno&hgta_track=cons100way&hgta_table=phastCons100way&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tscore"} {print $1,$2,$3,$4}' \
    | gsort /dev/stdin  $genome \
    | bgzip -c > hg19-phastcons-ucsc-v1.bedGraph.gz

tabix hg19-phastcons-ucsc-v1.bedGraph.gz

