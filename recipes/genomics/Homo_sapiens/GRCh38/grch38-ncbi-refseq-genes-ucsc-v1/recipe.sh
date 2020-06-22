#!/bin/sh
set -eo pipefail -o nounset

## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromosome mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get the Refseq Genes file
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/ncbiRefSeq.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=genes&hgta_track=refSeqComposite&hgta_table=ncbiRefSeq&hgta_doSchema=describe+table+schema\n#chrom\ttxStart\ttxEnd\tstrand\ttranscript_id\tgene_id\tcdsStart\tcdsEnd\texonCount\texonStarts\texonEnds\tcdsStartStatus\tcdsEndStatus\texonFrames"}
                               {print $3,$5,$6,$4,$2,$13,$7,$8,$9,$10,$11,$14,$15,$16}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-ncbi-refseq-genes-ucsc-v1.bed.gz

tabix grch38-ncbi-refseq-genes-ucsc-v1.bed.gz

