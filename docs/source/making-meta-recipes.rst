.. _contribute-meta-recipe:

Creating a ggd meta-recipe
==========================

[:ref:`Click here to return to the home page <home-page>`]

This page is specific to creating a ggd **meta-recipe**. If you are looking to create a normal ggd recipe see :ref:`Creating a ggd recipe <contrib-recipe>`



The following steps outline how to create, check, and add a ggd data meta-recipe. 

1. Update local forked repo
---------------------------
You will need to update the forked ggd-recipes repo on your local machine before
you add a recipe to it.

* Navigate to the forked ggd-recipes repo on your local machine
* Once in the directory run the following commands

::

    $ git checkout master
    $ git pull upstream master
    $ git push origin master



2. Writing the curation script(s) 
---------------------------------

A meta-recipe script should be quite a bit more detailed then a general ggd recipe script. 

Additionally, it is common to consider using multiple scripts for a meta-recipe, where you have a single main bash script which is used 
to control the process of all other scripts. 

.. note::

    Whether using a single or multiple scripts, the main script must be a bash script


Things to consider when building a meta-recipe (This list is by far NOT a comprehensive list of things to think about while creating a meta-recipe):

* What types of identifiers do I need in order to download the data from the database of choice?

* Are there different types of identifiers? If so, how do I handle them? 

* Does the database have and FTP site, a SQL database, etc? (How and where am I going to get the data from?)

* Is there a way to check if the ID and/or the data exists in the database? 

* How do I handle a bad ID or the absence of data? 

* Is there some hash value, like an md5sum hash value, I can use to validate that the contents of the data downloaded is correct and there wasn't an error during downloading?

* What data should be downloaded, and where is it coming from? 

* Is there additional processing that needs to happen once the data is downloaded? 

* With an ID, and potentially the downloaded data, what information can I get and used to update the ID specific recipe metadata? 

* How am I going to handle errors? 

* etc. 


Creating the main bash script 
+++++++++++++++++++++++++++++

This script should handle the ID. Data download, curation, etc. can be handled by this script or can be passed to a different supporting script. 

GGD provides 4 environment variables to use during meta-recipe installation in order to help the process. They are:

  +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
  | **GGD_METARECIPE_ID**                  | This is the ID provided during installation (Example: GSE123 for the GEO meta-recipe)                                                                 |
  +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
  | **SCRIPTS_PATH**                       | The directory path to where the additional scripts are stored. (This path is required in order to run any supporting scripts)                         |
  +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
  | **GGD_METARECIPE_ENV_VAR_FILE**        | This is the file path to store the ID specific updates to the meta-recipe. (More on this later)                                                       |
  +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+
  | **GGD_METARECIPE_FINAL_COMMANDS_FILE** | This is the file path to a bash script which is used to store the final/actual commands used to install the ID specific data. (More on this later)    |
  +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------+


In addition to providing these four environment variables these variables are passed into the main bash script as the first four parameters as follows: 
(Strict Order) 

.. code-block:: bash

   id=$1            # 1st argument is GGD_METARECIPE_ID

   script_path=$2   # 2nd argument is SCRIPTS_PATH

   env_var_file=$3  # 3rd argument is GGD_METARECIPE_ENV_VAR_FILE 

   commands_file=$4 # 4rth argument is GGD_METARECIPE_FINAL_COMMANDS_FILE


The **GGD_METARECIPE_ID** will match exactly what was entered in the install command. GGD will not change case or order. 


A) ID (GGD_METARECIPE_ID):


    The ID should be used to identify and download the data that is associated with that ID. If the ID doesn't exists or there is no data for that ID then the 
    bash script should print a warning/error message and exit. 


B) Script Path (SCRIPTS_PATH):

    In order to use a supporting script, the script path must be used. For example, if you have a supporting script named "get_id_metadata.py" which you run from within the main 
    bash script you would do:

    .. code-block:: bash

        script_path=$2   # 2nd argument is SCRIPTS_PATH

        python $script_path/get_id_metadata.py <other required arguments>

    or 

    .. code-block:: bash

        python $SCRIPTS_PATH/get_id_metadata.py <other required arguments>

    where <other required arguments> are the arguments needed for the "get_id_metadata.py" script.


C) Updating ID specific metadata (GGD_METARECIPE_ENV_VAR_FILE, GGD_METARECIPE_FINAL_COMMANDS_FILE):

    One of the main advantages of meta-recipes is the ability to update a recipes metadata based on information about the specific ID supplied. That is, 
    based on the ID what information is there that should be added to the metadata.

    Although it is not required to updated the metadata, it is highly recommended that you do. Otherwise, the metadata will consist of the general information
    of the meta-recipe without any ID specific info.

    GGD provides two environment variables to use for this purpose. 

    **GGD_METARECIPE_FINAL_COMMANDS_FILE**: This represents a bash file that should store the commands used for installing and processing the data files specific to the ID.

    The main meta-recipe script will being doing a lot of work. This file should capture the essential pieces for determining where and how the data was installed and processed. 
    Other information should be kept out. 

    This file acts as a place holder for what will be updated in the ID specific meta-recipe metadata. That is, after the meta-recipe is installed and the metadata has been 
    updated, a user will be able to access these commands through the :code:`ggd pkg-info` command. This helps to support reproducibility and transparency.

    Again, although it is not required it is highly recommended that this step is taken. 

    **GGD_METARECIPE_ENV_VAR_FILE**: This file represents different "environment variables" that can be set in order to update the metadata of an ID specific meta-recipe. 
    This file is a ``.json`` file. This means that the meta-recipe needs to save the contents of the file as a .json file, otherwise GGD will not be able to use the 
    updated environment variables. The json file should act as a dictionary/map with environment variable to change as keys and the content changes as values. 

    The available keys are:

      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_SUMMARY**                  | (string) A summary of the installed data                                                                                            |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_SPECIES**                  | (string) The species of the installed data                                                                                          |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_GENOME_BUILD**             | (string) The genome build of the installed data                                                                                     |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_VERSION**                  | (string) The version of the data installed                                                                                          |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_KEYWORDS**                 | (list)   A list of key words to add to the metadata                                                                                 |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_DATA_PROVIDER**            | (string) The data provider of the recipe. (Should already exists. Should not be used)                                               |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_FILE_TYPE**                | (list)   A list of file types for the files installed by the package                                                                |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
      | **GGD_METARECIPE_GENOMIC_COORDINATE_BASE**  | (string) A string that represented the coordinate base of the installed files                                                       |
      +---------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+

    Not all keys are required to be set. It is recommended that the **GGD_METARECIPE_SUMMARY** be updated, the **GGD_METARECIPE_SPECIES** and **GGD_METARECIPE_GENOME_BUILD** be 
    updated if data is available to update them, the **GGD_METARECIPE_VERSION** be updated, and the **GGD_METARECIPE_KEYWORDS** be updated. 

    The remaining keys/environment variable names can be used if data is available to update them. 

    .. note::

        The data provider can be updated, but it is recommended that the data provider is not updated. If the data provider needs to be updated 
        we suggest that a different recipe be created for that data provider specifically. 

    After an ID specific meta-recipe is installed, GGD will check to see if any of the two files exists. If they do, GGD will update the metadata of the ID specific 
    meta-recipe. These updates are available via the :code:`ggd pkg-info` command. 

    Please try to update the metadata whenever possible. 


    The meta-recipe main bash script should also clean up any extra files or other processes that were needed during the installation process. 


Creating the supporting script(s)
+++++++++++++++++++++++++++++++++

Supporting scripts are not needed if everything can be done easily in the main bash script without them. However, supporting scripts can be helpful 
in defining the updated metadata for the ID specific recipe installed, or for other tasks that aren't done easily in bash. 

Supporting scripts need to be accessible through the main bash script, and any arguments needed for the supporting scripts needs to be accessible and/or generated
within the main bash script. 

There is not requirement for language of supporting scripts. However, if a supporting script is written in another language other then bash, the language needs to be added 
to the dependencies list when making a ggd meta-recipe to ensure that the language is available when installing the meta-recipe

It is recommended that the json file used for updating the metadata be created from a supporting script because creating json files from a bash script is not 
as straight forward as it is in some other languages. For example, if you are using a python script to create the json file, a simple example would be: 

.. code-block:: python

    import json
    import os
    import sys

    json_outfile = sys.argv[1] ## This file path should be the GGD_METARECIPE_ENV_VAR_FILE passed in from the main bash script

    ## Create dictionary 
    metadata_dict = dict() 

    ## Add updated info to the  dictionary 
    metadata_dict["GGD_METARECIPE_SUMMARY"] = <updated summary> 

    .
    .
    .

    #save data as json file to the GGD_METARECIPE_ENV_VAR_FILE location
    json.dump(metadata_dict, open(json_outfile, "w"))

.. note::
    
    The json file needs to be formatted as a dictionary: {"GGD_METARECIPE_SUMMARY": "An Updated Summary", "GGD_METARECIPE_SPECIES": "ID specific species", ...}



Supporting scripts can be as simple or complicated as needs be. We recommend you stay on the side of simple as much as possible as to help provide transparency with
what is going on.

**An example of the GEO meta-recipe scripts are provided below at number 6**

3. Creating a ggd meta-recipe using the ggd cli
-----------------------------------------------

The ggd command line interface (cli) contains tools to create and test a data meta-recipe.


If it has not been installed, install the ggd cli following the steps outlined in :ref:`Using GGD <using-ggd>`.

With the ggd cli installed you can now transform your meta-recipe script(s) created in the previous step into a ggd meta-recipe.

To do this you will use the :code:`ggd make-meta-recipe` command. See the :ref:`make-meta-recipe <ggd-make-meta-recipe>` docs page for more information on the command . 

.. note:: 

    The :code:`make-meta-recipe` command is different then the :code:`make-recipe` command. The first creates a meta-recipe 
    while the second creates a normal ggd recipe. 

It is important that the summary of the meta-recipe provides enough information about what the meta-recipe is and what it does, as well as what it expects in terms of 
an ID, so that a user can simply identify which meta-recipe they would like to use and how to use it. 

None of the information added during the :code:`make-meta-recipe` stage should include ID specific information other then the summary stating how to use IDs. 

A meta-recipe requires the following fields to be field out:

  - species:         **"meta-recipe"**
  - genome build:    **"meta-recipe"**
  - data version:    **"meta-recipe"** (Not required, but suggested so that the version can be updated based on the installation of a specific ID recipe)
  - data provider:   The data provider where the meta-recipe will pull data from
  - summary:         A detailed summary of the meta-recipe 
  - author:          Who created the meta-recipe
  - package version: The version of the meta-recipe/package (Usually "1" for the first version of a meta-recipe)
  - keywords:        Keywords that will help to distinguish the meta-recipe
  - coordinate base: **"NA"** unless otherwise known. (Can be updated by the meta-recipe during an ID specific recipe installation)
  - name:            A defining name to use for the meta-recipe
  - script:          The main bash script for the meta-recipe
  - extra scripts:   A space separated list of all extra/supporting scripts that are used by the meta-recipe
  - dependency:      Any software or ggd data dependencies required by the main or supporting scripts of the meta-recipe


Example of making a meta-recipe:

.. code-block:: bash
    
  $ ggd make-meta-recipe \
        --authors mjc \
        --package-version 1 \
        --data-provider GEO \
        --data-version "meta-recipe" \
        --species "meta-recipe" \
        --genome-build "meta-recipe" \
        --cb "NA" \
        --summary "A meta-recipe for the Gene Expression Omnibus (GEO) database from NCBI. ... " \ 
        --extra-scripts parse_geo_header.py \
        -k Gene-Expression-Omnibus \
        -k GEO \
        -k GEO-Accession-ID \
        -k GEO-meta-recipe \
        --name geo-accession \
        geo_meta_recipe_script.sh

This will create a new ggd meta-recipe named **meta-recipe-geo-accession-geo-v1**

*meta-recipe-geo-accession-geo-v1* is a directory with the following files in it:

    - checksums_file.txt
    - meta.yaml 
    - metarecipe.sh
    - parse_geo_header.py
    - post-link.sh
    - recipe.sh


4. Checking/Testing the new meta-recipe
---------------------------------------

The new meta-recipe needs to be tested. GGD provides an easy to use tool to do this. The tool will check if the meta-recipe can be built into a data-package,
if it can be installed, along with other aspects of the recipe that are pertinent for successful data meta-recipes. 

This tool is :code:`ggd check-recipe`. :code:`check-recipe` is used to test both a normal ggd data recipe along with a ggd data meta-recipe. One major difference 
from the user side is that for a meta-recipe the :code:`--id` parameter is required while it is ignored during a normal recipe check.

This means that ggd will not only check that a meta-recipe works properly on its own, but also that it fulfills its requirements of installing ID specific data. 

Using the meta-recipe created in the previous step, you would run the following command in order to test the new meta-recipe:

.. code-block:: bash

    ggd check-recipe meta-recipe-geo-accession-geo-v1 --id GSE123

The ID can be any one of the IDs that can be used with the meta-recipe, :code:`check-recipe` just requires that a proper ID be used for testing.

.. note::

    :code:`check-recipe` will fail for a meta-recipe if no :code:`--id` is provided. 

    Additionally, the meta-recipe should be able to handle the occurrence of a bad ID. 


If :code:`check-recipe` fails there will be information on why it failed. Fix the problems and continue to test the meta-recipe until it passes.

Once the meta-recipe has passed the tests it can be added to GGD. 



5. Submit the new ggd meta-recipe to the original ggd-recipes repo
-------------------------------------------------------------------
Once the new ggd meta-recipe you created passes the previous step you are ready to add it to the original ggd-recipes repo.

To do this you will need to create a **pull request**.

From your local machine, add the new data meta-recipe you created to the forked ggd-recipes repo. You will add it
to the ``recipes/`` directory. If you do not put it in the right directory it will be rejected.
The recipes file convention is as follows:

    * All recipes are stored within the **ggd-recipes/recipes** directory
    * The recipes directory has the following format::

        /<path to forked ggd-recipes repo>/recipes/<ggd channel>/<species>/<genome-build>/

      * :code:`<path to forked ggd-recipes repo>` is the path to the forked ggd-recipes repo on your local machine.
      * :code:`recipes` is the **recipes** directory.
      * :code:`<ggd channel>` is the ggd channel that recipe should go in. This depends on the type of data you are adding.

        for a meta-recipe you should add it to:

        /<path to forked ggd-recipes repo>/recipes/<ggd channel>/**meta-recipe**/**meta-recipe**/

For the meta-recipe-geo-accession-geo-v1 meta-recipe created above you would use the following commands:

::

    $ mv meta-recipe-geo-accession-geo-v1 /<forked ggd-recipes>/recipes/genomics/meta-recipe/meta-recipe/

Once the meta-recipe is there you will need to add it to your forked ggd-recipe repo.
Navigate to the forked ggd-recipe directory and use the following commands:

    * Add the met-recipe to the git repo:

    ::

        $ git add /recipes/genomics/meta-recipe/meta-recipe/meta-recipe-geo-accession-geo-v1/

    * Commit the addition to the repo (The vim text editor will open up. Add a comment about the new meta-recipe and save it):

    ::

        $ git commit

    * Push the commit to your fork repo on github (You will be asked to fill out your github credentials):

    ::

        $ git push origin

    * Go to the ggd-recipes github page for your username (https://github.com/<USERNAME>/ggd-recipes/).

    * Under the green "Clone or download" button click on **Pull request**.

    * Where it says **base fork:** make sure it is on **gogetdata/ggd-recipes**. And where it says **base:** make sure it
      is on **master**.

    * Click the green **Create pull request** button.

    * Add some comments and complete the pull request.

You have now created a pull request with your new data meta-recipe. The meta-recipe will go through a continuous integration
step where the recipe will be tested.

If it passes, the recipe will be added to the gogetdata/ggd-recipes repo and anyone using the ggd tool will be
able to access it.

If it does not pass, you will be informed by the ggd team, and they will work with you on getting it working.


.. note::

    Because of the ID required by meta-recipes, there are additional steps that need to be taken during the continuous integration process. 
    In the pull request comments make sure to indicate the test ID you would like used during the testing phase. 
    The GGD team will work with you during this process to make sure that the process is done correctly.


6. Example of the Gene Expression Omnibus (GEO) main bash script and supporting python script
----------------------------------------------------------------------------------------------

Below is an example of a the main bash script and a supporting python script used to create a meta-recipe for the GEO database. This stands as one example 
of how to create a meta-recipe, but does not indicate how every meta-recipe should be created. As with all ggd recipes, the recipe scripts should be created 
in order to correctly install and process the data the recipe is created for. 


A) Main bash:

    .. code-block:: bash

        ## GEO accession number
        geo_acc_id=$1

        ## Script Location: The file path the script 
        script_path=$2

        ## Json File name 
        json_outfile=$3

        ## file path for the subsetted commands used to download the data
        commands_outfile=$4

        ## Force Upper Case
        #geo_acc_id=$(echo ${geo_acc_id^^}) Requires bash >= 4.2 (macOSX bash version == < 4)
        geo_acc_id="$(echo $geo_acc_id | tr '[:lower:]' '[:upper:]')"

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


B) Supporting python script named "parse_geo_header.py"

    .. code-block:: python

        from __future__ import print_function

        import argparse
        import datetime
        import gzip
        import io
        import json
        import os
        import sys
        from collections import defaultdict


        # ---------------------------------------------------------------------------------------------------------------------------------
        ## Argument Parser
        # ---------------------------------------------------------------------------------------------------------------------------------
        def arguments():
            """Argument method  """

            p = argparse.ArgumentParser(
                description="Parse GEO file header and update recipe meta-data"
            )

            req = p.add_argument_group("Required Arguments")

            req.add_argument(
                "--geo-acc",
                metavar="GEO Accession ID",
                required=True,
                help="The GEO accession ID",
            )

            req.add_argument(
                "--geo-file", metavar="GEO file", required=True, help="The GEO file to parse"
            )

            req.add_argument(
                "--geo-url",
                metavar="GEO Accession URL",
                required=True,
                help="The GEO Accession ID specific home page URL",
            )

            req.add_argument(
                "--geo-prefix",
                metavar="GEO Accession prefix",
                required=True,
                choices=["GDS", "GPL", "GSM", "GSE"],
                help="The GEO Accession id Prefix. (GDS, GPL, GSM, GSE)",
            )

            req.add_argument(
                "--geo-files-dir",
                metavar="GEO downloaded files",
                required=True,
                help="The directory path to where the files were downloaded",
            )

            req.add_argument(
                "--json-out",
                metavar="JSON out file",
                required=True,
                help="The name of the json output file to create that will contain the ggd meta-recipe environment variables",
            )

            return p.parse_args()


        # ---------------------------------------------------------------------------------------------------------------------------------
        ## Main
        # ---------------------------------------------------------------------------------------------------------------------------------


        def main():

            args = arguments()

            ## Open GEO File
            try:
                fh = (
                    gzip.open(args.geo_file, "rt", encoding="utf-8", errors="ignore")
                    if args.geo_file.endswith(".gz")
                    else io.open(args.geo_file, "rt", encoding="utf-8", errors="ignore")
                )
            except IOError as e:
                print("\n!!ERROR!! Unable to read the GEO File: '{}'".format(args.geo_file))
                print(str(e))
                sys.exit(1)

            print("\nParsing GEO header for file: {}".format(args.geo_file))

            metadata_dict = defaultdict(list)

            for i, line in enumerate(fh):

                line = line.strip()

                if not line:
                    continue

                ## Check if line is a header
                if line[0] == "!":

                    line_list = line.strip().split("=")

                    if len(line_list) > 1:
                        metadata_dict[line_list[0].replace(" ", "")].append(
                            line_list[1].strip()
                        )

            fh.close()

            geo_key = (
                "dataset"
                if args.geo_prefix == "GDS"
                else "Platform"
                if args.geo_prefix == "GPL"
                else "Sample"
                if args.geo_prefix == "GSM"
                else "Series"
                if args.geo_prefix == "GSE"
                else None
            )

            title = ", ".join(metadata_dict["!{}_title".format(geo_key)])

            summary = ", ".join(metadata_dict["!{}_summary".format(geo_key)])

            description = ", ".join(metadata_dict["!{}_description".format(geo_key)])

            etype = ", ".join(metadata_dict["!{}_type".format(geo_key)])

            status = ", ".join(metadata_dict["!{}_status".format(geo_key)])

            submission_date = ", ".join(metadata_dict["!{}_submission_date".format(geo_key)])

            last_update_date = ", ".join(metadata_dict["!{}_last_update_date".format(geo_key)])

            organism = set(
                [", ".join(list(set(y))) for x, y in metadata_dict.items() if "organism" in x]
            )

            pubmed_id = set(
                [", ".join(list(set(y))) for x, y in metadata_dict.items() if "pubmed_id" in x]
            )

            link = ", ".join(metadata_dict["!{}_web_link".format(geo_key)])

            ## Set summary environment variable
            env_vars = defaultdict(str)

            ## UPDATE META RECIPE SUMMARY
            new_summary = (
                "GEO Accession ID: {}. Title: {}. GEO Accession site url: {} (See the url for additional information about {}). ".format(
                    args.geo_acc, title, args.geo_url, args.geo_acc
                )
                + "Summary: "
                + summary
                + description
            )
            if etype:
                new_summary += " Type: {}".format(etype)

            env_vars["GGD_METARECIPE_SUMMARY"] = new_summary

            ## Update META RECIPE VERSION
            date_string = "Submission date: {}. Status: {}. Last Update Date: {}. Download Date: {}".format(
                submission_date,
                status,
                last_update_date,
                datetime.datetime.now().strftime("%m-%d-%Y"),
            )
            env_vars["GGD_METARECIPE_VERSION"] = date_string

            ## Update META RECIPE Keywords
            keywords = [
                args.geo_acc,
                args.geo_url,
                etype,
                "PubMed id: {}".format(", ".join(sorted(list(pubmed_id)))) if pubmed_id else "",
                "WEB LINK: {}".format(link) if link else "",
            ]
            env_vars["GGD_METARECIPE_KEYWORDS"] = ", ".join(keywords)

            ## Update META RECIPE SPECIES
            env_vars["GGD_METARECIPE_SPECIES"] = ", ".join(sorted(list(organism)))

            print("\nCreating environment variable json file: {}".format(args.json_out))
            json.dump(dict(env_vars), open(args.json_out, "w"))


        if __name__ == "__main__":
            sys.exit(main() or 0)


        


