#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O - ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh37_mapping/gencode.v34lift37.pc_translations.fa.gz\
    | gzip -dc \
    | bgzip -c > hg19_amino_acid-gencode-v1.fa.gz

samtools faidx hg19_amino_acid-gencode-v1.fa.gz
