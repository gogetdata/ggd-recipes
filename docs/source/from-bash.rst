.. _ggd-from-bash:

ggd from-bash
=============

ggd from-bash is used to create a ggd data recipe from a bash script which contains the information on 
extracting and processing the data. 

* **recipe**: A data recipe is directory containing a set of files that contain information about the recipe.
  This includes: A meta.yaml file, which is the meta data information for the soon to be ggd data package.
  A post-link script, which contains the information about file and data management. A recipe script, which
  contains the information on how to get the data and how to process it.

* **package**: A data package is created from building the ggd data recipe. It is a bgzipped tar file that contains 
  the built data recipe, and additional metadata information for conda system handeling. 

:code:`ggd from-bash` take a bash script created by you and turns it into a data recipe. This data recipe will then be 
turned into a data package using :ref:`ggd check-recipe <ggd-check-recipe>`. Finally, the new data package will
be added to the ggd repo and ggd conda channel through a continious integration system. (for more details see 
the :ref:`contribute <make-data-packages>` documentation)

The first step in this process is to create a bash script with instructions on downloading and process data, and 
then using :code:`ggd from-bash` to create a ggd data recipe


Using ggd from-bash
-------------------
Creating a ggd recipe is easy using the :code:`ggd from-bash` tool.
Running :code:`ggd from-bash -h` will give you the following help message:

.. code-block:: sh

    positional arguments:
        name                  name of recipe
        script                bash script that contains the commands that build the recipe

    optional arguments:
        -h, --help            show this help message and exit
        -c {genomics}, --channel {genomics} 
                        the ggd channel to use. (Default = genomics)
        -d DEPENDENCY, --dependency DEPENDENCY 
                        any software dependencies (in bioconda, conda-forge) or data-dependency (in ggd). May be as many times as needed.
        -e EXTRA_FILE, --extra-file EXTRA_FILE
                        any files that the recipe creates that are not a *.gz and *.gz.tbi pair. May be used more than once
        -p {noarch,none}, --platform {noarch,none}
                                Whether to use noarch as the platfrom or the system platform. If set to 'none' the system platform will be
                                used. (Default = noarch. Noarch means no architecture and is platform agnostic.)

    required arguments:
        -s {Canis_familiaris,Homo_sapiens,Drosophila_melanogaster,Mus_musculus}, --species {Canis_familiaris,Homo_sapiens,Drosophila_melanogaster,Mus_musculus}
                        species recipe is for
        -g GENOME_BUILD, --genome-build GENOME_BUILD
                        genome-build the recipe is for
        --authors AUTHORS     authors of the recipe
        -gv GGD_VERSION, --ggd_version GGD_VERSION
                        The version of the ggd package. (First time package = 1, updated package > 1)
        -dv DATA_VERSION, --data_version DATA_VERSION
                        The version of the data (itself) being downloaded and processed (EX: dbsnp-127)
        --summary SUMMARY     a comment describing the recipe
        -k KEYWORD, --keyword KEYWORD
                        a keyword to associate with the recipe. may be specified more that once.


Required Flags:

* -s: The :code:`-s` flag is used to declare the species the data recipe is for
* -g: The :code:`-g` flag is used to declare the genome-build the data recipe is for
* --authors: The :code:`--authors` flag is used to declare the authors of the recipe
* -gv: The :code:`-gv` flag is used to declare the ggd recipe version. (1 for first time recipe, and 2+ for updated recipes)
* -dv: The :code:`-dv` flag is used to declare the version of the data being downloaded and processed. If a version is not 
  avaiable for the specific data use something that can identify the data uniquely. (Such as the data when the data was created)
* --summary: The :code:`--summary` flag is used to provide a brief summary/description about the recipe  
* -k: The :code:`-k` flag is used to declare keywords associated with the data and recipe. If there are multiple keywords, the `-k` flag
  should be used for each keywords. (Example: -k ref -k reference)
* :code:`name` represents the name of the recipe 
* :code:`script` represents the bash script containing the information on data extraction and processing 

Optional Flags:

* -c: The :code:`-c` flag is used to declare which ggd channel to use. (genomics is the default) 
* -d: The :code:`-d` flag is used to declare software dependencies in conda, bioconda, and conda-forge, and data-dependencies in 
  ggd for creating the package. If there are not dependencies this flag is not needed
* -e: The :code:`-e` flag is used to declare any extra files created during the data processing. An extra file is any file that is 
  not a .gz and .gz.tbi pair. If your final processed files are .gz and .gz.tbi pair this flag is not needed.
* -p: The :code:`-p` flag is used to set the noarch platform or not. By default "noarch" is set, which means the package will be 
  built and installed with no architecture designation. This means it should be able to build on linux and macOSX. If this is not
  true you will need to set :code:`-p` to "none". The system you are using, linux or macOSX will take then take the place of noarch.


Example
-------

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

ggd from-bash

.. code-block:: bash

    $ ggd from-bash -s Homo_sapiens -g hg19 --author mjc --ggd_version 1 --data_version 27-Apr-2009 --summary 'Assembly gaps from USCS' -k gaps -k region gaps get_data.sh

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


ggd from-bash

.. code-block:: bash

    $ ggd from-bash -s Homo_sapiens -g GRCh37 --author mjc --ggd_version 1 --data_version ESP6500SI-V2 --summary 'ESP variants (More Info: http://evs.gs.washington.edu/EVS/#tabs-7)' -k ESP esp-variants get_data.sh

This code will create a new ggd recipe:

    * Directory Name: **grch37-esp-variants**
    * Files: **meta.yaml**, **post-link.sh**, **recipe.sh**
    

