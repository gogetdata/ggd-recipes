#!/bin/sh
set -eo pipefail -o nounset

## Get the phastcons bigwig file
wget --quiet --no-check-certificate --output-document hg38-phastcons-ucsc-v1.bw http://hgdownload.soe.ucsc.edu/goldenPath/hg38/phastCons100way/hg38.phastCons100way.bw

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
wget $genome

## Re-sort GRCh37.genome by numeric for bigwig conversion 
sort -k1,1 -k2,2n GRCh38.genome > GRCh38.genome.numeric.sorted

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Convert bigwig to bedgraph 
## Remap from UCSC hg19 to Ensembl GRCh37
bigWigToBedGraph hg38-phastcons-ucsc-v1.bw  /dev/stdout \
    | awk -v OFS="\t" 'BEGIN {print "#PhastCons info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=compGeno&hgta_track=cons100way&hgta_table=phastCons100way&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tscore"} 
                             {print $1,$2,$3,$4}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin  GRCh38.genome.numeric.sorted > temp_grch38-phastcons-ucsc-v1.bedGraph

rm hg38-phastcons-ucsc-v1.bw

## Update the length of MT from sed 16569, patch13, to 16571, patch12 
sed 's/MT\t16569/MT\t16571/' GRCh38.genome.numeric.sorted > GRCh38.genome.MT.updated

## Create new phastcon file remapped to GRCh37
bedGraphToBigWig temp_grch38-phastcons-ucsc-v1.bedGraph GRCh38.genome.MT.updated grch38-phastcons-ucsc-v1.bedGraph.bw

## Sort bedGraph, bgzip it, tabix it
gsort temp_grch38-phastcons-ucsc-v1.bedGraph $genome \
    | bgzip -c > grch38-phastcons-ucsc-v1.bedGraph.gz

tabix grch38-phastcons-ucsc-v1.bedGraph.gz

rm temp_grch38-phastcons-ucsc-v1.bedGraph
rm GRCh38.genome
rm GRCh38.genome.MT.updated
rm GRCh38.genome.numeric.sorted
