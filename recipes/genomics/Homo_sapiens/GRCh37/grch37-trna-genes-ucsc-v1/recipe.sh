#!/bin/sh
set -eo pipefail -o nounset



## Get the .genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome

## Get the chromomsome mapping file
chrom_mapping=$(ggd get-files grch37-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get and process the tRNA Genes from from UCSC
wget --quiet -O - http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/tRNAs.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" -v FS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg19&hgta_group=genes&hgta_track=tRNAs&hgta_table=tRNAs&hgta_doSchema=describe+table+schema\n#Genomic tRNA Database (GtRNAdb) Summary URL: http://gtrnadb2.ucsc.edu/genomes/eukaryota/Hsapi19/\n#chrom\tstart\tend\tstrand\ttRNA_gene_name\tamino_acid\tanti_codon\tintron_coordinates\ttRNA_ScanSE_Score\tGenomic_tRNA_Database_alignment_URL"}
                             {gsub("</BLOCKQUOTE>","", $10); gsub("<BLOCKQUOTE>","",$10); gsub(" ","-",$10); print $2,$3,$4,$7,$5,$8,$9,$10,$11,$13}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch37-trna-genes-ucsc-v1.bed.gz

tabix grch37-trna-genes-ucsc-v1.bed.gz
