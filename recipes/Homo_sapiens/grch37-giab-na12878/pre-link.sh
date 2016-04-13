#!/bin/bash
set -eo pipefail

# converted from: ../cloudbiolinux/ggd-recipes/GRCh37/giab-NA12878.yaml

mkdir -p $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-giab-na12878/ && cd $PREFIX/share/ggd/Homo_sapiens/GRCh37/grch37-giab-na12878/

dir=validation/giab-NA12878
mkdir -p $dir
wget -c -O $dir/truth_small_variants.vcf.gz ftp://ftp.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv2.19/NISTIntegratedCalls_14datasets_131103_allcall_UGHapMerge_HetHomVarPASS_VQSRv2.19_2mindatasets_5minYesNoRatio_all_nouncert_excludesimplerep_excludesegdups_excludedecoy_excludeRepSeqSTRs_noCNVs.vcf.gz
tabix -f -p vcf $dir/truth_small_variants.vcf.gz
wget -c -O - ftp://ftp.ncbi.nlm.nih.gov/giab/ftp/release/NA12878_HG001/NISTv2.19/union13callableMQonlymerged_addcert_nouncert_excludesimplerep_excludesegdups_excludedecoy_excludeRepSeqSTRs_noCNVs_v2.19_2mindatasets_5minYesNoRatio.bed.gz | gunzip -c | grep -v ^MT > $dir/truth_regions.bed
wget -O - ftp://ftp.ncbi.nih.gov/giab/ftp/technical/svclassify_Manuscript/Supplementary_Information/Personalis_1000_Genomes_deduplicated_deletions.bed | grep -v ^Chr > $dir/truth_DEL.bed
wget -O - ftp://ftp.ncbi.nih.gov/giab/ftp/technical/svclassify_Manuscript/Supplementary_Information/Spiral_Genetics_insertions.bed | grep -v ^Chr > $dir/truth_INS.bed
