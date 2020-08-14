#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh38.p13.genome.fa.gz\
    | gzip -dc \
    | bgzip -c > hg38-reference-genome-gencode-v1.fa.gz

samtools faidx hg38-reference-genome-gencode-v1.fa.gz
