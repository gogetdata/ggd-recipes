.. _ggd-make-recipe:

ggd make-recipe
===============

[:ref:`Click here to return to the home page <home-page>`]

ggd make-recipe is used to create a ggd data recipe from a bash script which contains the information on
extracting and processing the data.

* **recipe**: A data recipe is directory containing a set of files that contain information about the recipe.
  This includes: A meta.yaml file, which is the meta data information for the soon to be ggd data package;
  a post-link script, which contains the information about file and data management; and a recipe script, which
  contains the information on how to get the data and how to process it.

* **package**: A data package is created from building the ggd data recipe. It is a bgzipped tar file that contains
  the built data recipe and additional metadata information for conda system handling.

:code:`ggd make-recipe` takes a bash script created by you and turns it into a data recipe. This data recipe will then be
turned into a data package using :ref:`ggd check-recipe <ggd-check-recipe>`. Finally, the new data package will
be added to the ggd repo and ggd conda channel through a continuous integration system. For more details see
the :ref:`contribute <make-data-packages>` documentation.

The first step in this process is to create a bash script with instructions on downloading and data processing,
then using :code:`ggd make-recipe` to create a ggd data recipe.


Using ggd make-recipe
---------------------

Creating a ggd recipe is easy using the :code:`ggd make-recipe` tool.
Running :code:`ggd make-recipe -h` will give you the following help message:

make-recipe arguments: 

-h, --help                                      show this help message and exit

/name                                           (Positional) Name of recipe
                                                ('/' indicates a placeholder and is not part of the argument name)

/script                                         (Positional) Bash script that contains the commands that build the recipe
                                                ('/' indicates a placeholder and is not part of the argument name)

-c, --channel                                   (Optional) The ggd channel to use. (Default = genomics)

-d DEPENDENCY, --dependency DEPENDENCY          any software dependencies (in bioconda, conda-forge) or
                                                data-dependency (in ggd). May be as many times as needed.

-e EXTRA_FILE, --extra-file EXTRA_FILE          any files that the recipe creates that are not a \*.gz
                                                and \*.gz.tbi pair. May be used more than once.

-p, --platform                                  (Optional) Whether to use noarch as the platfrom or the system
                                                platform. If set to 'none' the system platform will be
                                                used. (Default = noarch. Noarch means no architecture
                                                and is platform agnostic.)

-s, --species                                   (Required) Species recipe is for

-g GENOME_BUILD, --genome-build GENOME_BUILD    (Required) Genome-build the recipe is for

--authors AUTHORS                               (Required) Authors of the recipe
    
-gv, --ggd_version                              (Required) The version of the ggd package. (First time package = 1,
                                                updated package > 1)
        
-dv, --data_version                             (Required) The version of the data (itself) being downloaded and
                                                processed (EX: dbsnp-127)

--summary SUMMARY                               (Required) A comment describing the recipe

-k KEYWORD, --keyword KEYWORD                   (Required) A keyword to associate with the recipe. may be specified
                                                more that once.


Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments: 

* *-s:* The :code:`-s` flag is used to declare the species of the data recipe.

* *-g:* The :code:`-g` flag is used to declare the genome-build of the data recipe.

* *--authors:* The :code:`--authors` flag is used to declare the authors of the recipe.

* *-gv:* The :code:`-gv` flag is used to declare the ggd recipe version. (1 for first time recipe, and 2+ for updated recipes)

* *-dv:* The :code:`-dv` flag is used to declare the version of the data being downloaded and processed. If a version is not
  available for the specific data, use something that can identify the data uniquely such as when the data was created.

* *--summary:* The :code:`--summary` flag is used to provide a brief summary/description of the recipe.

* *-k:* The :code:`-k` flag is used to declare keywords associated with the data and recipe. If there are multiple keywords, the `-k` flag
  should be used for each keywords. (Example: -k ref -k reference)

* *name:* :code:`name` represents the name of the recipe.

* *script:* :code:`script` represents the bash script containing the information on data extraction and processing.

Optional arguments:

* *-c:* The :code:`-c` flag is used to declare which ggd channel to use. (genomics is the default)

* *-d:* The :code:`-d` flag is used to declare software dependencies in conda, bioconda, and conda-forge, and data-dependencies in
  ggd for creating the package. If there are not dependencies this flag is not needed.

* *-e:* The :code:`-e` flag is used to declare any extra files created during the data processing. An extra file is any file that is
  not a .gz and .gz.tbi pair. If your final processed files are .gz and .gz.tbi pair this flag is not needed.

* *-p:* The :code:`-p` flag is used to set the noarch platform or not. By default "noarch" is set, which means the package will be
  built and installed with no architecture designation. This means it should be able to build on linux and macOS. If this is not
  true you will need to set :code:`-p` to "none". The system you are using, linux or macOS will take then take the place of noarch.


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
        | bgzip -c > gaps.bed.gz

    tabix gaps.bed.gz

ggd make-recipe

.. code-block:: bash

    $ ggd make-recipe -s Homo_sapiens -g hg19 --author mjc --ggd_version 1 --data_version 27-Apr-2009 --summary 'Assembly gaps from USCS' -k gaps -k region gaps get_data.sh

This code will create a new ggd recipe:

    * Directory Name: **hg19-gaps**
    * Files: **meta.yaml**, **post-link.sh**, and **recipe.sh**

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
    reference_fasta="$(ggd list-files 'grch37-reference-genome' -s 'Homo_sapiens' -g 'GRCh37' -p 'hs37d5.fa')"

    # get the santizer script
    wget --quiet https://raw.githubusercontent.com/arq5x/gemini/00cd627497bc9ede6851eae2640bdaff9f4edfa3/gemini/annotation_provenance/sanit

    # sanitize
    zless ESP6500SI.all.snps_indels.vcf.gz | python sanitize-esp.py | bgzip -c > temp.gz
    tabix temp.gz

    # decompose with vt
    vt decompose -s temp.gz | vt normalize -r $reference_fasta - \
        | perl -pe 's/\([EA_|T|AA_]\)AC,Number=R,Type=Integer/\1AC,Number=R,Type=String/' \
        | bgzip -c > ESP6500SI.all.snps_indels.tidy.vcf.gz

    tabix ESP6500SI.all.snps_indels.tidy.vcf.gz

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

    $ ggd make-recipe -s Homo_sapiens -g GRCh37 --author mjc --ggd_version 1 --data_version ESP6500SI-V2 --summary 'ESP variants (More Info: http://evs.gs.washington.edu/EVS/#tabs-7)' -k ESP esp-variants get_data.sh

This code will create a new ggd recipe:

    * Directory Name: **grch37-esp-variants**
    * Files: **meta.yaml**, **post-link.sh**, **recipe.sh**
