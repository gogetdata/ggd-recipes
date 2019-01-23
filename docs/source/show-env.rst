.. _ggd-show-env:

ggd show-env
============

ggd show-env is a tool used to show the ggd associated variables created during package installation 
for the current conda enviroment. 
During installation, ggd will place the processed files in a specific location on your system. To access
these files ggd creates enviroment variables for a specific conda enviroment. These variables contain the 
directory path to the processed files. You can use :code:`ggd list-files` to find the file paths for a ggd data
package, however, these enviroment variables provide quick access to the processed files without having to know 
the file paths.


Using ggd show-env
------------------
You can use ggd show-env to get a list of ggd data package enviroment variables. 
Running :code:`ggd show-env -h` will give you the following message:

.. code-block:: bash

    usage: ggd show-env [-h] [-p PATTERN]

    optional arguments:
        -h, --help            show this help message and exit
        -p PATTERN, --pattern PATTERN
                              regular expression pattern to match the name of the variable desired

There are no required arguemnts for using :code:`ggd show-env`, however, you can refine the results using 
the :code:`-p` flag. 
    

Example
-------

1. Using ggd show-env
+++++++++++++++++++++

.. code-block:: bash

    $ ggd show-env

      *****************************

      Active environment variables:
      > $ggd_hg19_repeatmasker
      > $ggd_grch37_esp_variants
      > $ggd_hg38_repeatmasker
      > $ggd_grch37_reference_genome
      > $ggd_hg19_phastcons
      > $ggd_hg19_gaps
      > $ggd_hg38_simplerepeats
      > $ggd_hg19_simplerepeats
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
      > $ggd_hg19_phastcons
      > $ggd_hg19_gaps
      > $ggd_hg19_repeatmasker
      > $ggd_hg19_simplerepeats
      .
      .
      .

      *****************************


