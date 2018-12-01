#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/giab-NA12878.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/
genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/GRCh37/GRCh37.genome

dir=validation/giab-NA12878
mkdir -p $dir
wget --quiet -c -O $dir/truth_small_variants.vcf.gz ftp://ftp.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv2.19/NISTIntegratedCalls_14datasets_131103_allcall_UGHapMerge_HetHomVarPASS_VQSRv2.19_2mindatasets_5minYesNoRatio_all_nouncert_excludesimplerep_excludesegdups_excludedecoy_excludeRepSeqSTRs_noCNVs.vcf.gz
gsort $dir/truth_small_variants.vcf.gz $genome | bgzip -c > t.vcf.gz
mv t.vcf.gz $dir/truth_small_variants.vcf.gz
tabix $dir/truth_small_variants.vcf.gz

wget --quiet -c -O - ftp://ftp.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv2.19/union13callableMQonlymerged_addcert_nouncert_excludesimplerep_excludesegdups_excludedecoy_excludeRepSeqSTRs_noCNVs_v2.19_2mindatasets_5minYesNoRatio.bed.gz | gunzip -c | grep -v ^MT > $dir/truth_regions.bed
gsort $dir/truth_regions.bed $genome | bgzip -c > $dir/truth_regions.bed.gz
tabix $dir/truth_regions.bed.gz
rm $dir/truth_regions.bed

wget --quiet -O - ftp://ftp.ncbi.nih.gov/giab/ftp/technical/svclassify_Manuscript/Supplementary_Information/Personalis_1000_Genomes_deduplicated_deletions.bed | grep -v ^Chr > $dir/truth_DEL.bed
gsort $dir/truth_DEL.bed $genome | bgzip -c > $dir/truth_DEL.bed.gz
tabix $dir/truth_DEL.bed.gz
rm $dir/truth_DEL.bed


wget --quiet -O - ftp://ftp.ncbi.nih.gov/giab/ftp/technical/svclassify_Manuscript/Supplementary_Information/Spiral_Genetics_insertions.bed | grep -v ^Chr > $dir/truth_INS.bed
gsort $dir/truth_INS.bed $genome | bgzip -c > $dir/truth_INS.bed.gz
tabix $dir/truth_INS.bed.gz
rm $dir/truth_INS.bed
