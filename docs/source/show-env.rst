.. _ggd-show-env:

ggd show-env
============

[:ref:`Click here to return to the home page <home-page>`]

ggd show-env is a tool used to show the ggd associated variables created during package installation
for the current conda environment.

During installation, ggd will place the processed files in a specific location on your system. To access
these files ggd creates upt to two environment variables for each data package within a specific conda environment. 
These variables contain the either the directory path to the processed files or the file path to the main data file. 
You can use :code:`ggd list-files` or :code:`ggd pkg-info` to find additional file paths for a ggd data
package, however, these environment variables provide quick access to the processed files without having to know
the file paths.

For details on using these environment variables in your analysis scripts see: :ref:`Using installed data <using-installed-data>`.


Using ggd show-env
------------------
You can use ggd show-env to get a list of ggd data package enviroment variables.
Running :code:`ggd show-env -h` will give you the following message:

show-env arguments:

-h, --help                      show this help message and exit

-p PATTERN, --pattern PATTERN   (Optional) Regular expression pattern to match the name of the variable desired


Additional argument explanation: 
++++++++++++++++++++++++++++++++

There are no required arguments for using :code:`ggd show-env`, however, you can refine the results using
the :code:`-p` flag.

.. note:: 

   Environemnt variables ending with `_dir` point to the directory path of the installed data package.
   
   Environment variables ending with `_file` point to the main file from the installed data package. 


Examples
--------

1. Using ggd show-env
+++++++++++++++++++++

.. code-block:: bash

    $ ggd show-env

      *****************************

      Active environment variables:
      > $ggd_hg19_repeatmasker_ucsc_v1_dir
      > $ggd_hg19_repeatmasker_ucsc_v1_file
      > $ggd_grch37_esp_variants_ensembl_v1_dir
      > $ggd_grch37_esp_variants_ensembl_v1_file
      > $ggd_hg38_repeatmasker_ucsc_v1_dir
      > $ggd_hg38_repeatmasker_ucsc_v1_file
      > $ggd_grch37_reference_genome_ensembl_v1_dir
      > $ggd_grch37_reference_genome_ensembl_v1_file
      > $ggd_hg19_phastcons_ucsc_v1_dir
      > $ggd_hg19_phastcons_ucsc_v1_file
      > $ggd_hg19_gaps_ucsc_v1_dir
      > $ggd_hg19_gaps_ucsc_v1_file
      > $ggd_hg38_simplerepeats_ucsc_v1_dir
      > $ggd_hg38_simplerepeats_ucsc_v1_file
      > $ggd_hg19_simplerepeats_ucsc_v1_dir
      > $ggd_hg19_simplerepeats_ucsc_v1_file
      .
      .
      .

      *****************************

2. Using the `-p` flag
++++++++++++++++++++++

.. code-block:: bash

    $ ggd show-env -p ggd_hg19

      *****************************

      Active environment variables:
      > $ggd_hg19_phastcons_ucsc_v1_dir
      > $ggd_hg19_phastcons_ucsc_v1_file
      > $ggd_hg19_gaps_ucsc_v1_dir
      > $ggd_hg19_gaps_ucsc_v1_file
      > $ggd_hg19_repeatmasker_ucsc_v1_dir
      > $ggd_hg19_repeatmasker_ucsc_v1_file
      > $ggd_hg19_simplerepeats_ucsc_v1_dir
      > $ggd_hg19_simplerepeats_ucsc_v1_file
      .
      .
      .

      *****************************
