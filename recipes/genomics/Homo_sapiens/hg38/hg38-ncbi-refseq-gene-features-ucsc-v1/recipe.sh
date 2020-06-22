#!/bin/sh
set -eo pipefail -o nounset


## Get the ggd genome file
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome

## Get and process the NCBI Refseq ALL gtf file
wget --quiet -O -  http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz \
    | gzip -dc \
    | awk -v OFS="\t" 'BEGIN {print "#Data info: https://genome.ucsc.edu/cgi-bin/hgTrackUi?hgsid=828607149_h0XfhN0FSAO8AbnAAH5NX7hrZs6U&c=chr1&g=refSeqComposite\n#Data annotation = RefSeq All\n#chrom\tsource\tfeature\tstart\tend\tscore\tstrand\tframe\tattribute"} 
                             {print $0}' \
    | gsort /dev/stdin $genome \
    | bgzip -c > hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

tabix hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz

