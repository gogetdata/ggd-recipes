#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")
awk '{if (NR > 1) print $1,$2} ' $chrom_mapping \
    | sort -k2,2n -r \
    | awk '{print "s/"$1"/"$2"/g"}' > remap.sed

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/chainSelf.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=chainSelf&hgta_table=chainSelf&hgta_doSchema=describe+table+schema\n#target_chrom\ttarget_start\ttarget_end\ttarget_size\tquery_chrom\tquery_start\tquery_end\tquery_size\tquery_strand\tchain_id\tscore\tnormalized_score"} 
                             {print $3,$5,$6,$4,$7,$10,$11,$8,$9,$12,$2,$13}' \
    | sed -f remap.sed \
    | gsort /dev/stdin $genome \
    | bgzip -c > grch38-selfchain-ucsc-v1.bed.gz

tabix grch38-selfchain-ucsc-v1.bed.gz

rm remap.sed


