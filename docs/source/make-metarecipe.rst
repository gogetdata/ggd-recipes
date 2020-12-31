.. _ggd-make-meta-recipe:

ggd make-meta-recipe
=====================

[:ref:`Click here to return to the home page <home-page>`]

For general information on meta-recipes see :ref:`Meta-Recipes <meta-recipes>`

ggd make-meta-recipe is used to create a ggd data meta-recipe from a single or group of script which contains the information on
extracting and processing the data.

This provides a simple resource to create a recipe where the users need only create the scripts and 
ggd will generate the remainder of the pieces required for a ggd data meta-recipe.

This process is very similar to creating a ggd recipe, however, it does require a bit more work. Please see the 
docs on  :ref:`contributing <make-data-packages>` recipes to ggd for more information on creating a ggd meta-recipe.

The first step in this process is to create a bash script, and subsequent support scripts if needed, with instructions 
on downloading and processing the data, then using :code:`ggd make-meta-recipe` to create a ggd data meta-recipe

Using ggd make-meta-recipe
--------------------------

Creating a ggd meta-recipe is easy using the :code:`ggd make-meta-recipe` tool.
Running :code:`ggd make-meta-recipe -h` will give you the following help message:


make-recipe arguments: 

+---------------------------------------------+---------------------------------------------------------------------------+
| ggd make-recipe                             | Make a ggd data meta-recipe                                               |
+=============================================+===========================================================================+
| ``-h``, ``--help``                          | show this help message and exit                                           |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-c``, ``--channel``                       | (Optional) The ggd channel to use. (Default = genomics)                   |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-d``, ``--dependency``                    | any software dependencies (in bioconda, conda-forge) or                   |
|                                             | data-dependency (in ggd). May be used as many times as needed.            |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-p``, ``--platform``                      | (Optional) Whether to use noarch as the platform or the system            |
|                                             | platform. If set to 'none' the system platform will be                    |
|                                             | used. (Default = noarch. Noarch means no architecture                     |
|                                             | and is platform agnostic.)                                                |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-s``, ``--species``                       | **Required** Species recipe is for. Use 'meta-recipe` for a metarecipe    | 
|                                             | file                                                                      |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-g``, ``--genome-build``                  | **Required** Genome-build the recipe is for. Use 'metarecipe' for a       |
|                                             | metarecipe file                                                           |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``--author``                                | **Required** The author(s) of the data recipe being created, (This recipe)|
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-pv``, ``--package-version``              | **Required** The version of the ggd package. (First time package = 1,     |
|                                             | updated package > 1)                                                      |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-dv``, ``--data-version``                 | **Required** The version of the data (itself) being downloaded and        |
|                                             | processed (EX: dbsnp-127) If there is no data version                     |
|                                             | apparent we recommend you use the date associated with                    |
|                                             | the files or something else that can uniquely identify                    |
|                                             | the 'version' of the data. Use 'metarecipe' for a metarecipe              |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-dp``, ``--data-provider``                | **Required** The data provider where the data was accessed.               |
|                                             | (Example: UCSC, Ensembl, gnomAD, etc.)                                    |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``--summary``                               | **Required** A detailed comment describing the recipe                     |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-k``, ``--keyword``                       | **Required** A keyword to associate with the recipe. May be               |
|                                             | specified more that once. Please add enough keywords                      |
|                                             | to better describe and distinguish the recipe                             |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-cb``, ``--coordinate-base``              | **Required** The genomic coordinate basing for the file(s) in the         |
|                                             | recipe. That is, the coordinates exclusive start at genomic               |
|                                             | coordinate 0 or 1, and the end coordinate is either                       |
|                                             | inclusive (everything up to and including the end                         |
|                                             | coordinate) or exclusive (everything up to but not                        |
|                                             | including the end coordinate) Files that do not have                      |
|                                             | coordinate basing, like fasta files, specify NA for                       |
|                                             | not applicable. Use 'NA' for a metarecipe                                 |
+---------------------------------------------+---------------------------------------------------------------------------+
+ ``--extra-scripts``                         | Any additional scripts used for the metarecipe that are not the main bash | 
|                                             | script                                                                    |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-n``, ``--name``                          | **Required** The sub-name of the recipe being created. (e.g. cpg-         |
|                                             | islands, pfam-domains, gaps, etc.) This will not be                       |
|                                             | the final name of the recipe, but will specific to the data gathered      |
|                                             | and processed by the recipe                                               |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``script``                                  | **Required** bash script that contains the commands to obtain and         |
|                                             | process the data                                                          | 
+---------------------------------------------+---------------------------------------------------------------------------+

Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments: 

* *-s:* The :code:`-s` flag is used to declare the species of the data recipe. Use "meta-recipe" for a meta-recipe.

* *-g:* The :code:`-g` flag is used to declare the genome-build of the data recipe. Use "meta-recipe" for a meta-recipe.

* *--authors:* The :code:`--authors` flag is used to declare the authors of the ggd data recipe.

* *-pv:* The :code:`-pv` flag is used to declare the version of the ggd recipe being created. (1 for first time recipe, and 2+ for updated recipes)

* *-dv:* The :code:`-dv` flag is used to declare the version of the data being downloaded and processed. If a version is not
  available for the specific data, use something that can identify the data uniquely such as when the date the data. Use "meta-recipe" for a meta-recipe.
  was created.

* *-dp:* The :code:`-dp` flag is used to designate where the original data is coming from. Please make sure to indicate the data provider correctly to 
  both give credit to the data create/provider as well as to help uniquely identify the data origin. 

* *--summary:* The :code:`--summary` flag is used to provide a summary/description of the meta-recipe. Provide enough information to explain what the data is and 
  where it is coming from. Provide information on what ID is required in order to install the data. Add any information that will help explain the meta-recipe.

* *-k:* The :code:`-k` flag is used to declare keywords associated with the data and meta-recipe. If there are multiple keywords, the `-k` flag
  should be used for each keywords. (Example: -k ref -k GEO)

* *-cb:* The :code:`-cb` flag designates the coordinate base of the data files created from this recipe. Please follow general genomic file 
  coordinate standards based on the file format you are creating. Please indicate the coordinate basing of the file created here using this
  flag. For meta-recipes it is common to use "NA".
   
* *-n:* :code:`-n` represents the sub-name of the meta-recipe. Sub-name refers to a portion of the name that will help to uniquely identify the 
  recipe from all other recipes based on the data the recipe creates. The full name will include the genome build the data provider and the 
  ggd recipe version. **DO NOT** include the genome build, data provider, or ggd recipe version here. Those will be designated with other flags. 
  The name should be specific to the data being processed or curated by the recipe. (Please provide an identifiable name. Example: cpg-islands) 

* *script:* :code:`script` represents the main bash script containing the information on data extraction and processing.

Optional arguments:

* *extra-scripts:* The :code:`extra-scripts` parameter is used to add any additional scripts used for the meta-recipe that are not the main bash script. 
  If the main bash script, for example, uses a python script to set ID specific meta-recipe environment variables, then that python script should be added
  here. To add mutliple, seperate each script by a space aftter the :code:`--extra-scripts` parameter. (Example :code:`--extra-scripts script1.sh script2.py script3.prl`)

* *-c:* The :code:`-c` flag is used to declare which ggd channel to use. (genomics is the default)

* *-d:* The :code:`-d` flag is used to declare software dependencies in conda, bioconda, and conda-forge, and data-dependencies in
  ggd for creating the package. If there are no dependencies this flag is not needed.

* *-p:* The :code:`-p` flag is used to set the noarch platform or not. By default "noarch" is set, which means the package will be
  built and installed with no architecture designation. This means it should be able to build on linux and macOS. If this is not
  true you will need to set :code:`-p` to "none". The system you are using, linux or macOS will take then take the place of noarch.

.. note::

    meta-recipes allow for information to be updated as an ID specific meta-recipe is installed. That is, for example, the summary, data version, 
    key words, etc. can be updated while installing the ID specific recipe where the updated information reflects the information for the ID specific 
    data. For more information see the contribute tab.


Examples
--------

1. A simple example of creating a ggd recipe
++++++++++++++++++++++++++++++++++++++++++++

ggd make-recipe

.. code-block:: bash

  $ ggd make-meta-recipe \
        --authors mjc \
        --package-version 1 \
        --data-provider GEO \
        --data-version "meta-recipe" \
        --species "meta-recipe" \
        --genome-build "meta-recipe" \
        --cb "NA" \
        --summary "A meta-recipe for the Gene Expression Omnibus (GEO) database from NCBI. This meta-recipe contains the instructions for accessing GEO data using GEO Accession IDs. GEO Datasets (GDS), GEO Platforms (GPL), GEO Series (GSE), and GEO Samples (GSM) are all accessible through this meta-recipe. Files downloaded for each type are: (GDS) SOFT files. (GPL) SOFT files and ANNOT files if they exist. (GSE) SOFT file and MATRIX files if they exist. (GSM) The main table file as a .txt file. Additionally, for all 4 types, all supplemental files are downloaded if they exist. Once installed, GEO ID specific recipes will contain ID specific info, such as a summary of the data and a url to the GEO Accession ID specific page. This info can be accessed using 'ggd pkg-info'. To install simply add the '--id' flag with the desired GEO Accession ID when running 'ggd install'. Additional info about GEO can be found at http://www.ncbi.nlm.nih.gov/geo" \
        --extra-scripts parse_geo_header.py \
        -k Gene-Expression-Omnibus \
        -k GEO \
        -k GEO-Accession-ID \
        -k GEO-meta-recipe \
        --name geo-accession \
        geo_meta_recipe_script.sh

    :ggd:make-recipe: checking meta-recipe

    :ggd:make-recipe: Wrote output to meta-recipe-geo-accession-geo-v1/

    :ggd:make-recipe: To test that the recipe is working, and before pushing the new recipe to gogetdata/ggd-recipes, please run: 

        $ ggd check-recipe meta-recipe-geo-accession-geo-v1/ --id

This code will create a new ggd recipe:

    * Directory Name: **meta-recipe-geo-accession-geo-v**
    * Files: **meta.yaml**, **post-link.sh**, **recipe.sh**, **metarecipe.sh**, and **checksums_file.txt**

.. note:: 

  The directory name **meta-recipe-geo-accession-geo-v1/** is the ggd meta-recipe


