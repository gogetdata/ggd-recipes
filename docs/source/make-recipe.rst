.. _ggd-make-recipe:

ggd make-recipe
===============

[:ref:`Click here to return to the home page <home-page>`]

ggd make-recipe is used to create a ggd data recipe from a bash script which contains the information on
extracting and processing the data.

This provides a simple resource to create a recipe where the users need only create the base script and 
ggd will generate the remainder of the pieces required for a ggd data recipe.

* **recipe**: A data recipe is a directory containing a set of files that comprise information about the recipe.
  This includes: A meta.yaml file, which is the meta data information for the soon to be ggd data package;
  a post-link script, which contains the information about file and data management; a recipe script, which
  contains the information on how to get the data and how to process it; and a checksum file, which is used
  to ensure that the contents of the data files installed from ggd have not changed. 

* **package**: A data package is created from building/packaging the ggd data recipe. It is a bgzipped tar 
  file that contains the built data recipe and additional metadata information for conda system handling.


:code:`ggd make-recipe` takes a bash script created by you and turns it into a data recipe. This data recipe will then be
turned into a data package using :ref:`ggd check-recipe <ggd-check-recipe>`. Finally, the new data package will
be added to the ggd repo and ggd conda channel through an automatic continuous integration system. For more details see
the :ref:`contribute <make-data-packages>` documentation.

The first step in this process is to create a bash script with instructions on downloading and processing the data,
then using :code:`ggd make-recipe` to create a ggd data recipe



Using ggd make-recipe
---------------------

Creating a ggd recipe is easy using the :code:`ggd make-recipe` tool.
Running :code:`ggd make-recipe -h` will give you the following help message:


make-recipe arguments: 

+---------------------------------------------+---------------------------------------------------------------------------+
| ggd make-recipe                             | Make a ggd data recipe from a bash script                                 |
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
| ``-s``, ``--species``                       | **Required** Species recipe is for                                        |
+---------------------------------------------+---------------------------------------------------------------------------+
| ``-g``, ``--genome-build``                  | **Required** Genome-build the recipe is for                               |
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
|                                             | the 'version' of the data                                                 |
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
|                                             | not applicable.                                                           |
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

* *-s:* The :code:`-s` flag is used to declare the species of the data recipe.

* *-g:* The :code:`-g` flag is used to declare the genome-build of the data recipe.

* *--authors:* The :code:`--authors` flag is used to declare the authors of the ggd data recipe.

* *-pv:* The :code:`-pv` flag is used to declare the version of the ggd recipe being created. (1 for first time recipe, and 2+ for updated recipes)

* *-dv:* The :code:`-dv` flag is used to declare the version of the data being downloaded and processed. If a version is not
  available for the specific data, use something that can identify the data uniquely such as when the date the data
  was created.

* *-dp:* The :code:`-dp` flag is used to designate where the original data is coming from. Please make sure to indicate the data provider correctly to 
  both give credit to the data create/provider as well as to help uniquely identify the data origin. 

* *--summary:* The :code:`--summary` flag is used to provide a summary/description of the recipe. Provide enough information to explain what the data is and 
  where it is coming from.

* *-k:* The :code:`-k` flag is used to declare keywords associated with the data and recipe. If there are multiple keywords, the `-k` flag
  should be used for each keywords. (Example: -k ref -k reference)

* *-cb:* The :code:`-cb` flag designates the coordinate base of the data files created from this recipe. Please follow general genomic file 
  coordinate standards based on the file format you are creating. Please indicate the coordinate basing of the file created here using this
  flag.
   
* *-n:* :code:`-n` represents the sub-name of the recipe. Sub-name refers to a portion of the name that will help to uniquely identify the 
  recipe from all other recipes based on the data the recipe creates. The full name will include the genome build the data provider and the 
  ggd recipe version. **DO NOT** include the genome build, data provider, or ggd recipe version here. Those will be designated with other flags. 
  The name should be specific to the data being processed or curated by the recipe. (Please provide an identifiable name. Example: cpg-islands) 

* *script:* :code:`script` represents the bash script containing the information on data extraction and processing.

Optional arguments:

* *-c:* The :code:`-c` flag is used to declare which ggd channel to use. (genomics is the default)

* *-d:* The :code:`-d` flag is used to declare software dependencies in conda, bioconda, and conda-forge, and data-dependencies in
  ggd for creating the package. If there are no dependencies this flag is not needed.

* *-p:* The :code:`-p` flag is used to set the noarch platform or not. By default "noarch" is set, which means the package will be
  built and installed with no architecture designation. This means it should be able to build on linux and macOS. If this is not
  true you will need to set :code:`-p` to "none". The system you are using, linux or macOS will take then take the place of noarch.


Data recipe standards
---------------------
1) The name of the data recipe should be short, simple, but identifiable and unique. For example, if you are creating a recipe that access 
   the cpg-islands track from UCSC you would provide the name `cpg-islands` for the name parameter when running :code:`ggd make-recipes`. 
   The final recipe name will contain the genome build, the name provider using :code:`-n`, the data provider, and the version. (`hg19-cpg-islands-ucsc-v1`)

2) The data should be named after the recipe name. Please make sure all data that is produced by the recipe prior to the file extensions is named after the recipe name. 

3) Please add many keywords. Keywords help to distinguish and describe the data files. Please add as many keywords that can help to distinguish and describe the data

4) Data files should be labeled and sorted consistently across different genome builds. The data sorting standard for ggd data recipes is regulated by a tool called `gsort`.
   Please us `gsort` whenever you need to sort genomic data files. (`gsort` can be installed with conda if it is not on your system now.) The associated genome files used 
   with gsort can be found at `ggd-recipes/genomes <https://github.com/gogetdata/ggd-recipes/tree/master/genomes>`_. If the desired genome file for a specific genome build 
   is not available raise an issue on `ggd-recipes::issues <https://github.com/gogetdata/ggd-recipes/issues>`_ and someone from the ggd team will help. 
   ggd also uses `check-sort-order` for additional QC of the data. If you are unsure about the sort order of your data please test it with `check-sort-order`



Examples
--------

1. A simple example of creating a ggd recipe
++++++++++++++++++++++++++++++++++++++++++++

get_data.sh:

.. code-block:: bash

    genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
    wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
        | gzip -dc \
        | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
        | gsort /dev/stdin $genome \
        | bgzip -c > hg19-gaps-ucsc-v1.bed.gz

    tabix hg19-gaps-ucsc-v1.bed.gz

ggd make-recipe

.. code-block:: bash

  $ ggd make-recipe -s Homo_sapiens -g hg19 --author mjc -pv 1 -dv 27-Apr-2009 -dp UCSC --summary 'Assembly gaps from USCS' -k gaps -k region -cb 0-based-inclusive -n gaps data_script.sh 

    :ggd:make-recipe: checking hg19

    :ggd:make-recipe: Wrote output to hg19-gaps-ucsc-v1/

    :ggd:make-recipe: To test that the recipe is working, and before pushing the new recipe to gogetdata/ggd-recipes, please run: 
        $ ggd check-recipe hg19-gaps-ucsc-v1/

This code will create a new ggd recipe:

    * Directory Name: **hg19-gaps-ucsc-v1**
    * Files: **meta.yaml**, **post-link.sh**, **recipe.sh**, and **checksums_file.txt**

.. note:: 

  The directory name **hg19-gaps-ucsc-v1** is the ggd recipe

2. A more complex ggd recipe
++++++++++++++++++++++++++++

get_data.sh

.. code-block:: bash

    wget --quiet http://evs.gs.washington.edu/evs_bulk_data/ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz

    # extract individual chromosome files
    tar -zxf ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz

    # combine chromosome files into one
    (grep ^# ESP6500SI-V2-SSA137.GRCh38-liftover.chr1.snps_indels.vcf; cat ESP6500SI-V2-SSA137.GRCh38-liftover.chr*.snps_indels.vcf | grep

    # sort the chromosome data according to the .genome file from github
    gsort temp.vcf https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh37/GRCh37.genome \
        | bgzip -c > ESP6500SI.all.snps_indels.vcf.gz

    # tabix it
    tabix -p vcf ESP6500SI.all.snps_indels.vcf.gz

    # get handle for reference file
    reference_fasta="$(ggd get-files 'grch37-reference-genome-1000g-v1' -s 'Homo_sapiens' -g 'GRCh37' -p 'grch37-reference-genomie-1000g-v1.fa')"

    # get the sanitizer script
    wget --quiet https://raw.githubusercontent.com/arq5x/gemini/00cd627497bc9ede6851eae2640bdaff9f4edfa3/gemini/annotation_provenance/sanit

    # sanitize
    zless ESP6500SI.all.snps_indels.vcf.gz | python sanitize-esp.py | bgzip -c > temp.gz
    tabix temp.gz

    # decompose with vt
    vt decompose -s temp.gz | vt normalize -r $reference_fasta - \
        | perl -pe 's/\([EA_|T|AA_]\)AC,Number=R,Type=Integer/\1AC,Number=R,Type=String/' \
        | bgzip -c > grch37-esp-variants-uw-v1.vcf.gz

    tabix grch37-esp-variants-uw-v1.vcf.gz 

    # clean up environment
    rm ESP6500SI-V2-SSA137.GRCh38-liftover.snps_indels.vcf.tar.gz
    rm ESP6500SI-V2-SSA137.GRCh38-liftover.chr*.snps_indels.vcf

    rm ESP6500SI.all.snps_indels.vcf.gz.tbi
    rm ESP6500SI.all.snps_indels.vcf.gz

    rm temp.gz
    rm temp.gz.tbi
    rm temp.vcf

    rm sanitize-esp.py


ggd make-recipe

.. code-block:: bash

  $ ggd make-recipe \
        -s Homo_sapiens \
        -g GRCh37 \
        --author mjc \
        -pv 1 \
        -dv ESP6500SI-V2 \
        -dp UW \
        --summary 'ESP variants (More Info: http://evs.gs.washington.edu/EVS/#tabs-7)' \
        -k ESP \
        -k vcf-file \
        -cb 1-based-exclusive \
        -d grch37-reference-genome-1000g-v1 \
        -d gsort \
        -d vt \
        -n esp-variants \
        data_script.sh 

    :ggd:make-recipe: checking GRCh37

    :ggd:make-recipe: Wrote output to grch37-esp-variants-uw-v1/

    :ggd:make-recipe: To test that the recipe is working, and before pushing the new recipe to gogetdata/ggd-recipes, please run: 
      $ ggd check-recipe grch37-esp-variants-uw-v1/

This code will create a new ggd recipe:

    * Directory Name: **grch37-esp-variants-uw-v1**
    * Files: **meta.yaml**, **post-link.sh**, **recipe.sh**, and **checksums_file.txt**


.. note:: 

  The directory name **grch37-esp-variants-uw-v1** is the ggd recipe



