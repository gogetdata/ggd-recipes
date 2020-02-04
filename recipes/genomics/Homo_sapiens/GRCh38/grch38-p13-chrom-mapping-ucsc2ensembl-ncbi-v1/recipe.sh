#!/bin/sh
set -eo pipefail -o nounset

# -------------------------------------------------------------------------------------------------------
# header fields: 
# Column 1: $_Sequence_Name
# Column 2: $Sequence_Role 
# Column 3: $Assigned_Molecule 
# Column 4: $Assigned_Molecule_Location_Type 
# Column 5: $GenBank_Accn 
# Column 6: $Relationship 
# Column 7: $RefSeq_Accn 
# Column 8: $Assembly_Unit 
# Column 9: $Sequence_Length 
# Column 10: $UCSC_style_name  
# -------------------------------------------------------------------------------------------------------

## Install bioawk
conda install -c bioconda -y bioawk

which bioawk


## Get the report file from NCBI
wget --quiet ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.28_GRCh38.p13/GCA_000001405.28_GRCh38.p13_assembly_report.txt

## Process the report  file
cat <(grep "^#" GCA_000001405.28_GRCh38.p13_assembly_report.txt | tail -n 1) <(grep -v "^#" GCA_000001405.28_GRCh38.p13_assembly_report.txt) \
    | sed 's/ //g' \
    | bioawk -tc header 'NR>1 {print $GenBank_Accn,$UCSC_style_name}' \
    | sed -e "s/CM000663.2/1/g" \
    | sed -e "s/CM000664.2/2/g" \
    | sed -e "s/CM000665.2/3/g" \
    | sed -e "s/CM000666.2/4/g" \
    | sed -e "s/CM000667.2/5/g" \
    | sed -e "s/CM000668.2/6/g" \
    | sed -e "s/CM000669.2/7/g" \
    | sed -e "s/CM000670.2/8/g" \
    | sed -e "s/CM000671.2/9/g" \
    | sed -e "s/CM000672.2/10/g" \
    | sed -e "s/CM000673.2/11/g" \
    | sed -e "s/CM000674.2/12/g" \
    | sed -e "s/CM000675.2/13/g" \
    | sed -e "s/CM000676.2/14/g" \
    | sed -e "s/CM000677.2/15/g" \
    | sed -e "s/CM000678.2/16/g" \
    | sed -e "s/CM000679.2/17/g" \
    | sed -e "s/CM000680.2/18/g" \
    | sed -e "s/CM000681.2/19/g" \
    | sed -e "s/CM000682.2/20/g" \
    | sed -e "s/CM000683.2/21/g" \
    | sed -e "s/CM000684.2/22/g" \
    | sed -e "s/CM000685.2/X/g" \
    | sed -e "s/CM000686.2/Y/g" \
    | sed -e "s/J01415.2/MT/g" > chrommapping.txt

## Save the report file with a header
cat <(grep -E "^[1-9]+|^[X]|^[Y]|^(MT)" chrommapping.txt | sort -k1,1) \
    <(grep -E -v "^[1-9]+|^[X]|^[Y]|^(MT)" chrommapping.txt | sort -k2,2) \
    | sed "s/\r//g" \
    | awk 'BEGIN {print "UCSC_id\tEnsembl_id"}  {if ( $2 != "na" ) { print $2"\t"$1}}' > grch38_chrom_mapping_ucsc2ensembl_ncbi.txt

## Remove extra files
rm chrommapping.txt
rm GCA_000001405.28_GRCh38.p13_assembly_report.txt

