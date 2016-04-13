#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/mm10/mirbase.yaml

mkdir -p $PREFIX/share/ggd/Mus_musculus/mm10/mm10-srnaseq/ && cd $PREFIX/share/ggd/Mus_musculus/mm10/mm10-srnaseq/

mkdir -p srnaseq
cd srnaseq
wget -q -N -c http://hgdownload.soe.ucsc.edu/goldenPath/mm10/database/wgEncodeGencodeBasicVM4.txt.gz
zcat  wgEncodeGencodeBasicVM4.txt.gz | awk '{print $3"\t.\tencode\t"$5+1"\t"$6"\t.\t"$4"\t.\tname "$13";"}' | awk '$5-$4 < 500' > srna-transcripts.gtf
wget -q -N -c http://hgdownload.soe.ucsc.edu/goldenPath/mm10/database/tRNAs.txt.gz
zcat tRNAs.txt.gz | awk '{print $2"\t.\ttRNA\t"$3+1"\t"$4"\t.\t"$7"\t.\tname "$5";"}' >> srna-transcripts.gtf
wget -q -N -c http://hgdownload.soe.ucsc.edu/goldenPath/mm10/database/rmsk.txt.gz
zcat rmsk.txt.gz | awk '{print $6"\t.\trepeat\t"$7+1"\t"$8+1"\t.\t"$10"\t.\tname "$12";"}' >> srna-transcripts.gtf
wget -q -N -c ftp://mirbase.org/pub/mirbase/20/genomes/mmu.gff3
awk '$3=="miRNA"' mmu.gff3 | sed 's/=/ /g' >> srna-transcripts.gtf
wget -q -N -c -O hairpin.fa.gz ftp://mirbase.org/pub/mirbase/21/hairpin.fa.gz
zcat hairpin.fa.gz |  awk '{if ($0~/>mmu/){name=$0; print name} else if ($0~/^>/){name=0};if (name!=0 && $0!~/^>/){print $0;}}' | sed 's/U/T/g'  > hairpin.fa
wget -q -N -c -O mature.fa.gz ftp://mirbase.org/pub/mirbase/21/mature.fa.gz
zcat mature.fa.gz |  awk '{if ($0~/>mmu/){name=$0; print name} else if ($0~/^>/){name=0};if (name!=0 && $0!~/^>/){print $0;}}' | sed 's/U/T/g'  > mature.fa
wget -q -N -c -O miRNA.str.gz ftp://mirbase.org/pub/mirbase/21/miRNA.str.gz
zcat miRNA.str.gz | awk '{if ($0~/mmu/)print $0}' > miRNA.str
wget --no-check-certificate -q -N -c -O Rfam_for_miRDeep.fa.gz https://github.com/lpantano/mirdeep2_core/raw/data/Rfam_for_miRDeep.fa.gz && gunzip Rfam_for_miRDeep.fa.gz
# targetscan analysis
wget --no-check-certificate -q -N -c -O Summary_Counts.txt.zip http://www.targetscan.org/mmu_71/mmu_71_data_download/Summary_Counts.all_predictions.txt.zip && unzip Summary_Counts.txt.zip
wget --no-check-certificate -q -N -c -O miR_Family_Info.txt.zip http://www.targetscan.org/mmu_71/mmu_71_data_download/miR_Family_Info.txt.zip && unzip miR_Family_Info.txt.zip
wget --no-check-certificate -q -N -c ftp://mirbase.org/pub/mirbase/21/database_files/mirna_mature.txt.gz
# tdrmapper
wget --no-check-certificate -N -c -O trna_mature_pre.fa https://github.com/sararselitsky/tDRmapper/raw/master/mm10_mature_pre_for_tdrMapper.fa
