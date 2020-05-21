#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome

## Get the chromosome mapping file
chrom_mapping=$(ggd get-files grch38-chrom-mapping-ucsc2ensembl-ncbi-v1 --pattern "*.txt")

## Get and process the NCBI Refseq ALL gtf file
wget --quiet -O -  http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Data info: https://genome.ucsc.edu/cgi-bin/hgTrackUi?hgsid=828607149_h0XfhN0FSAO8AbnAAH5NX7hrZs6U&c=chr1&g=refSeqComposite\n#Data annotation = RefSeq All\n#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} 
                             {print $0}' \
    | gsort --chromosomemappings $chrom_mapping /dev/stdin $genome \
    | bgzip -c > grch38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

tabix grch38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

