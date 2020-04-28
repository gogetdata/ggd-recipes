#!/bin/sh
set -eo pipefail -o nounset

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg38/database/simpleRepeat.txt.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Table Info: https://genome.ucsc.edu/cgi-bin/hgTables?db=hg38&hgta_group=rep&hgta_track=simpleRepeat&hgta_table=simpleRepeat&hgta_doSchema=describe+table+schema\n#chrom\tstart\tend\tsequence\tscore\tstrand\tperiod\tcopy_num\tconsensusSize\tperMatch\tperIndel\tperA\tperC\tperG\tperT"} 
                        {print $2,$3,$4,$17,$11,"+",$6,$7,$8,$9,$10,$12,$13,$14,$15}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-simplerepeats-ucsc-v1.bed.gz

tabix hg38-simplerepeats-ucsc-v1.bed.gz
