#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.lncRNA_transcripts.fa.gz\
    | gzip -dc \
    | bgzip -c > grch38-reference-genome-gencode-v1.fa.gz

samtools faidx grch38-reference-genome-gencode-v1.fa.gz
