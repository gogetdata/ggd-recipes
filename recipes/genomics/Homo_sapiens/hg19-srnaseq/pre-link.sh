#!/bin/bash
set -exo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/hg19/mirbase.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/hg19/ && cd $PREFIX/share/ggd/Homo_sapiens/hg19/

mkdir -p srnaseq
cd srnaseq
wget -q -N -c -O hsa.gff3 ftp://mirbase.org/pub/mirbase/20/genomes/hsa.gff3
awk '$3=="miRNA"' hsa.gff3 | sed 's/=/ /g' > srna-transcripts.gtf
rm hsa.gff3
wget -q -N -c -O wgRna.txt.gz http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/wgRna.txt.gz
zgrep -v 'hsa-' wgRna.txt.gz | awk '{print $2"\t.\tncrna\t"$3"\t"$4"\t.\t"$7"\t.\tname "$5";"}' >> srna-transcripts.gtf
rm wgRna.txt.gz
wget -q -c http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/tRNAs.txt.gz
ls -lh
gzip -dc tRNAs.txt.gz | awk '{print $2"\t.\ttRNA\t"$3"\t"$4"\t.\t"$7"\t.\tname "$5";"}' >> srna-transcripts.gtf
rm -f tRNAs.txt.gz
wget -q -N -c -O rmsk.txt.gz http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/rmsk.txt.gz
gzip -dc rmsk.txt.gz | awk '{print $6"\t.\trepeat\t"$7+1"\t"$8+1"\t.\t"$10"\t.\tname "$12";"}' >> srna-transcripts.gtf
rm rmsk.txt.gz
wget -q -N -c -O refGene.txt.gz http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database/refGene.txt.gz
gzip -dc refGene.txt.gz | awk '{print $3"\t.\tgene\t"$5"\t"$6"\t.\t"$4"\t.\tname "$13";"}' >> srna-transcripts.gtf
rm refGene.txt.gz

genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/hg19/hg19.genome
gsort srna-transcripts.gtf $genome | bgzip -c > srna-transcripts.gtf.gz
tabix srna-transcripts.gtf.gz

rm -f hsa.gff3 srna-transcripts.gtf

# wget http://www.regulatoryrna.org/database/piRNA/download/archive/v1.0/bed/piR_hg19_v1.0.bed.gz
# gzip -dc piR_hg19_v1.0.bed.gz | awk '{print $1"\t.\tpiRNA\t"$2"\t"$3"\t.\t"$6"\t.\tname "$4";"}' >> srna-transcripts.gtf
wget -q -N -c -O hairpin.fa.gz ftp://mirbase.org/pub/mirbase/21/hairpin.fa.gz
gzip -dc hairpin.fa.gz |  awk '{if ($0~/>hsa/){name=$0; print name} else if ($0~/^>/){name=0};if (name!=0 && $0!~/^>/){print $0;}}' | sed 's/U/T/g'  > hairpin.fa
rm hairpin.fa.gz
samtools faidx hairpin.fa
wget -q -N -c -O mature.fa.gz ftp://mirbase.org/pub/mirbase/21/mature.fa.gz
gzip -dc mature.fa.gz |  awk '{if ($0~/>hsa/){name=$0; print name} else if ($0~/^>/){name=0};if (name!=0 && $0!~/^>/){print $0;}}' | sed 's/U/T/g'  > mature.fa
samtools faidx mature.fa
rm mature.fa.gz
wget -q -N -c -O miRNA.str.gz ftp://mirbase.org/pub/mirbase/21/miRNA.str.gz
gzip -dc miRNA.str.gz | awk '{if ($0~/hsa/)print $0}' > miRNA.str
rm miRNA.str.gz

wget  --no-check-certificate -q -N -c -O trna_mature_pre.fa https://github.com/sararselitsky/tDRmapper/raw/master/hg19_mature_and_pre.fa
samtools faidx trna_mature_pre.fa

wget --no-check-certificate -q -N -c -O Rfam_for_miRDeep.fa.gz https://github.com/lpantano/mirdeep2_core/raw/data/Rfam_for_miRDeep.fa.gz && gunzip Rfam_for_miRDeep.fa.gz

samtools faidx Rfam_for_miRDeep.fa

# targetscan analysis
wget --no-check-certificate -q -N -c -O Summary_Counts.txt.zip http://www.targetscan.org/vert_70/vert_70_data_download/Summary_Counts.all_predictions.txt.zip && unzip Summary_Counts.txt.zip
rm Summary_Counts.txt.zip

wget --no-check-certificate -q -N -c -O miR_Family_Info.txt.zip http://www.targetscan.org/vert_70/vert_70_data_download/miR_Family_Info.txt.zip && unzip miR_Family_Info.txt.zip
rm miR_Family_Info.txt.zip
wget --no-check-certificate -q -N -c ftp://mirbase.org/pub/mirbase/21/database_files/mirna_mature.txt.gz


