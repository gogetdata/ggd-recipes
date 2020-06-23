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

## Get the report file from NCBI
wget --quiet ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.14_GRCh37.p13/GCA_000001405.14_GRCh37.p13_assembly_report.txt 

## Process the report  file
cat <(grep "^#" GCA_000001405.14_GRCh37.p13_assembly_report.txt | tail -n 1) <(grep -v "^#" GCA_000001405.14_GRCh37.p13_assembly_report.txt) \
    | sed 's/ //g' \
    | bioawk -tc header 'NR>1 {print $GenBank_Accn,$RefSeq_Accn}' \
    | sed -e "s/CM000663.1/1/g" \
    | sed -e "s/CM000664.1/2/g" \
    | sed -e "s/CM000665.1/3/g" \
    | sed -e "s/CM000666.1/4/g" \
    | sed -e "s/CM000667.1/5/g" \
    | sed -e "s/CM000668.1/6/g" \
    | sed -e "s/CM000669.1/7/g" \
    | sed -e "s/CM000670.1/8/g" \
    | sed -e "s/CM000671.1/9/g" \
    | sed -e "s/CM000672.1/10/g" \
    | sed -e "s/CM000673.1/11/g" \
    | sed -e "s/CM000674.1/12/g" \
    | sed -e "s/CM000675.1/13/g" \
    | sed -e "s/CM000676.1/14/g" \
    | sed -e "s/CM000677.1/15/g" \
    | sed -e "s/CM000678.1/16/g" \
    | sed -e "s/CM000679.1/17/g" \
    | sed -e "s/CM000680.1/18/g" \
    | sed -e "s/CM000681.1/19/g" \
    | sed -e "s/CM000682.1/20/g" \
    | sed -e "s/CM000683.1/21/g" \
    | sed -e "s/CM000684.1/22/g" \
    | sed -e "s/CM000685.1/X/g" \
    | sed -e "s/CM000686.1/Y/g" \
    | sed -e "s/J01415.2/MT/g" > chrommapping.txt

## Save the report file with a header
cat <(grep -E "^[1-9]+|^[X]|^[Y]|^(MT)" chrommapping.txt | sort -k1,1) \
    <(grep -E -v "^[1-9]+|^[X]|^[Y]|^(MT)" chrommapping.txt | sort -k2,2) \
    | sed "s/\r//g" \
    | awk 'BEGIN {print "#Ensembl_id\tRefSeq_id"}  {if ( $2 != "na" ) { print $1"\t"$2}}' > grch37_chrom_mapping_ensembl2refseq_ncbi.txt

## Remove extra files
rm chrommapping.txt
rm GCA_000001405.14_GRCh37.p13_assembly_report.txt
