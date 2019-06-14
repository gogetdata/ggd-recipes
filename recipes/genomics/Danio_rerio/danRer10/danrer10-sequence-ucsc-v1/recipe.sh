#!/bin/sh
set -eo pipefail -o nounset
#!/bin/sh
set -eo pipefail -o nounset

wget --quiet -O danrer10-sequence-ucsc-v1.fa.gz ftp://hgdownload.soe.ucsc.edu/goldenPath/danRer10/bigZips/danRer10.fa.gz
bgzip -fd danrer10-sequence-ucsc-v1.fa.gz
samtools faidx danrer10-sequence-ucsc-v1.fa
