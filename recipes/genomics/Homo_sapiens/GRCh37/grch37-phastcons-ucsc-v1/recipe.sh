#!/bin/sh
set -eo pipefail -o nounset

## Get the phastcon bigwig file
wget --quiet --no-check-certificate --output-document hg19-phastcons-ucsc-v1.bw http://hgdownload.cse.ucsc.edu/goldenpath/hg19/phastCons100way/hg19.100way.phastCons.bw

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome
wget $genome

## Re-sort GRCh37.genome by numeric for bigwig conversion 
sort -k1,1 -k2,2n GRCh37.genome > GRCh37.genome.numeric.sorted

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Convert bigwig to bedgraph 
## Remap from UCSC hg19 to Ensembl GRCh37
bigWigToBedGraph hg19-phastcons-ucsc-v1.bw  /dev/stdout \
    | awk -v OFS="\t" 'BEGIN {print "#PhastCons info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=compGeno&hgta_track=cons100way&hgta_table=phastCons100way&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tscore"} 
                             {print $1,$2,$3,$4}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin  GRCh37.genome.numeric.sorted > temp_grch37-phastcons-ucsc-v1.bedGraph

rm hg19-phastcons-ucsc-v1.bw

## Update the length of MT from sed 16569, patch13, to 16571, patch12 
sed 's/MT\t16569/MT\t16571/' GRCh37.genome.numeric.sorted > GRCh37.genome.MT.updated

## Create new phastcon file remapped to GRCh37
bedGraphToBigWig temp_grch37-phastcons-ucsc-v1.bedGraph GRCh37.genome.MT.updated grch37-phastcons-ucsc-v1.bedGraph.bw

## Sort bedGraph, bgzip it, tabix it
gsort temp_grch37-phastcons-ucsc-v1.bedGraph $genome \
    | bgzip -c > grch37-phastcons-ucsc-v1.bedGraph.gz

tabix grch37-phastcons-ucsc-v1.bedGraph.gz

rm temp_grch37-phastcons-ucsc-v1.bedGraph
rm GRCh37.genome
rm GRCh37.genome.MT.updated
rm GRCh37.genome.numeric.sorted
