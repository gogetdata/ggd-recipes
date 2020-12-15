#!/bin/sh
set -eo pipefail -o nounset


## GEO accession number
geo_acc_id=$1

## Script Location: The file path the script 
script_path=$2

## Json File name 
json_outfile=$3

## file path for the subseted commands used to download the data
commands_outfile=$4

## Force Upper Case
geo_acc_id=$(echo ${geo_acc_id^^})

echo -e "\n    Checking GEO for $geo_acc_id"
echo -e "  ================================\n"

## Get the GEO number excluding the prefix
geo_digit="${geo_acc_id//[^[:digit:]]/}"

## Get GEO URL stub based on the number of digits
if [[ "${#geo_digit}" -ge 3 ]]
then
    stub=$(echo "$geo_acc_id" | sed 's/...$/nnn/')

elif [[ "${#geo_digit}" -eq 2 ]]
then
    stub=$(echo "$geo_acc_id" | sed 's/..$/nnn/')

elif [[ "${#geo_digit}" -eq 1 ]]
then
    stub=$(echo "$geo_acc_id" | sed 's/.$/nnn/')

fi

## URL vars
prefix=""
soft_url=""
matrix_url=""
annot_url=""
gsm_url=""
sup_url=""

## Check accession number prefix
if [[ $geo_acc_id == "GDS"* ]]
then

    ## Set PREFIX
    prefix="GDS"

    ## Get the soft file from the dataset
    soft_url="https://ftp.ncbi.nlm.nih.gov/geo/datasets/$stub/$geo_acc_id/soft/$geo_acc_id.soft.gz"

    ## Supplemental URL
    sup_url="https://ftp.ncbi.nlm.nih.gov/geo/datasets/$stub/$geo_acc_id/suppl/"


elif [[ $geo_acc_id == "GSE"* ]]
then

    ## Set PREFIX
    prefix="GSE"

    ## Get the soft file for the series
    soft_url="https://ftp.ncbi.nlm.nih.gov/geo/series/$stub/$geo_acc_id/soft/$geo_acc_id""_family.soft.gz"
    ## Get the matrix file for the series
    matrix_url="https://ftp.ncbi.nlm.nih.gov/geo/series/$stub/$geo_acc_id/matrix/$geo_acc_id""_series_matrix.txt.gz"

    ## Supplemental URL
    sup_url="https://ftp.ncbi.nlm.nih.gov/geo/series/$stub/$geo_acc_id/suppl/"

elif [[ $geo_acc_id == "GPL"* ]]
then

    ## Set PREFIX
    prefix="GPL"

    ## Get the soft file for the platform
    soft_url="https://ftp.ncbi.nlm.nih.gov/geo/platforms/$stub/$geo_acc_id/soft/$geo_acc_id""_family.soft.gz"
    ## Get the annot file for the platform
    annot_url="https://ftp.ncbi.nlm.nih.gov/geo/platforms/$stub/$geo_acc_id/annot/$geo_acc_id.annot.gz"
    ## Supplemental URL
    sup_url="https://ftp.ncbi.nlm.nih.gov/geo/platforms/$stub/$geo_acc_id/suppl/"

elif [[ $geo_acc_id == "GSM"* ]]
then

    ## Set PREFIX
    prefix="GSM"
    
    ## Get the Table file from the CGI GEO Query site
    gsm_url="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=$geo_acc_id&form=text&view=full"
    ## Supplemental URL
    sup_url="https://ftp.ncbi.nlm.nih.gov/geo/samples/$stub/$geo_acc_id/suppl/"

else ## Bad accession prefix
    echo -e "\n!!ERROR!! GEO does not recognized the supplied accession id: '$geo_acc_id'." 1>&2 
    echo -e "  Acceptable accession prefix include: \n\t- GDSxxx  \n\t- GPLxxx  \n\t- GSMxxx \n\t- GSExxx\n" 1>&2  
    exit 1

fi


## Check if accession id exists
message=$(xmllint --xpath "string(//WarningList)" <(curl "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=gds&term=$geo_acc_id" --silent))

if [[ $message == *"No items found"* ]]
then
    ## If accession ID not found 
    echo -e "!!ERROR!! Accession ID $geo_acc_id not found in GEO\n" 1>&2
    exit 1
else
    echo -e "Found Accession ID in GEO: $geo_acc_id\n"
fi


## Get the Accession URL for the GEO Accession page
geo_acc_url="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=$geo_acc_id"

echo -e "Main GEO page for $geo_acc_id: $geo_acc_url\n"

echo -e "Checking $geo_acc_id for available files"
echo -e "-------------------------------------\n"

final_commands=""
## Check for SOFT URL
if [[ ! -z $soft_url ]]
then
    ## Check if soft url file exists
    if curl --output /dev/null --silent --head --fail "$soft_url"
    then
        echo -e "\tDownloading SOFT file: $soft_url\n"
        ## Download file
        ## GEOxxx.soft.gz file
        ##     or
        ## GEOxxx_family.soft.gz file
        curl "$soft_url" -O -J --silent
        final_commands="""$final_commands
curl \"$soft_url\" -O -J --silent
"""
    fi
fi

## Check for MATRIX URL
if [[ ! -z $matrix_url ]]
then
    ## Check if matrix url file exists
    if curl --output /dev/null --silent --head --fail "$matrix_url"
    then
        echo -e "\tDownloading MATRIX file: $matrix_url\n"
        ## Download file
        ## GEOxxx_series_matrix.txt.gz file
        curl "$matrix_url" -O -J --silent
        final_commands="""$final_commands
curl \"$matrix_url\" -O -J --silent
"""
    fi
fi

## Check for ANNOT URL
if [[ ! -z $annot_url ]]
then
    ## Check if annot url file exists
    if curl --output /dev/null --silent --head --fail "$annot_url"
    then
        echo -e "\tDownloading ANNOT file: $annot_url\n"
        ## Download file
        ## GEOxxx.annot.gz file
        curl "$annot_url" -O -J --silent
        final_commands="""$final_commands
curl \"$annot_url\" -O -J --silent
"""
    fi
fi

## Check for GSM URL
if [[ ! -z $gsm_url ]]
then
    ## Check if gsm url file exists
    if curl --output /dev/null --silent --head --fail "$gsm_url"
    then
        echo -e "\tDownloading table: $gsm_url\n"
        ## Download file
        ## GEOxxx.txt file
        curl "$gsm_url" -O -J --silent
        final_commands="""$final_commands
curl \"$gsm_url\" -O -J --silent
"""
    fi
fi


## Check for Supplemental URL
if [[ ! -z $sup_url ]]
then
    ## Check if sup url exists
    if curl --output /dev/null --silent --head --fail "$sup_url"
    then
        ## Iterate over all GEO Accession ID specific files in sup url
        for file in $(curl "$sup_url" --silent | grep -oE  "<a href=".+?">.+?<\/a>" | cut -f 2 -d '"' | grep  "^$geo_acc_id")
        do
            ## Build sup file url
            sup_file_url="$sup_url$file"

            ## Check if it exists
            if curl --output /dev/null --silent --head --fail "$sup_file_url"
            then
                ## Download file
                ## GEOxxx sup file
                echo -e "\tDownloading Sup. File: $sup_file_url\n"
                curl "$sup_file_url" -O -J --silent
                final_commands="""$final_commands
curl \"$sup_file_url\" -O -J --silent
"""
                
                ## Check for tar file
                if [[ "$file" == *".tar"* ]]
                then 
                    echo -e "\t\tExtracting TAR File $file"

                    ## Extract TAR file
                    if [[ "$file" == *".tar" ]]
                    then
                        tar -xf $file
                        final_commands="""$final_commands
tar -xf $file
"""
                    elif [[ "$file" == *".tar.gz" ]]
                    then
                        tar -xzf $file
                        final_commands="""$final_commands
tar -xzf $file
"""
                    elif [[ "$file" == *".tar.bz2" ]]
                    then
                        tar -xjf $file
                        final_commands="""$final_commands
tar -xjf $file
"""
                    else
                        echo -e "!!ERROR!! Unable to extract tar file" 1>&2
                        exit 1
                    fi
                    
                    ## remove the tar file
                    rm $file
                fi
            fi
        done
    fi
fi


## Commands used to download the data files
echo "$final_commands" > $commands_outfile

## Get the main file to parse the header from
### For GDS, GPL, and GSE the .soft file should be used
### For GSM, the .txt file should be used
main_file=""
submain_file=""
for file in $(pwd)/*
do 
    if [[ $prefix == "GSM" ]]
    then

        if [[ "$file" == *".txt" ]]
        then 
            main_file=$file
        fi

    else
        if [[ "$file" == *".soft"* ]]
        then
            main_file=$file
        elif [[ "$file" == *"matrix"* ]]
        then
            submain_file=$file
        fi
    fi
done

## If GSE and soft file does not exists, use the matrix file
if [[ $main_file == "" ]]
then
    main_file=$submain_file
fi

## Update ID Specific meta-recipe 
python $script_path/parse_geo_header.py --geo-acc $geo_acc_id --geo-file $main_file  --geo-url $geo_acc_url --geo-prefix $prefix --geo-files-dir $(pwd) --json-out $json_outfile  

echo -e "DONE\n"
