.. _ggd-list-files:

ggd list-files
==============

ggd list-files is used to list the files associated with a ggd data package that has been installed on your system
using :code:`ggd install`.

.. note::

    If the data package has not been installed on your system :code:`ggd list-files` will not be able to list the files.


This tool is used to find the location of a file(s) downloaded using ggd. For example, if you downloaded the GRCh37
reference genome using :code:`ggd install grch37-reference-genome` and you want the fasta file and the tabix file you would
run :code:`ggd list-files grch37-reference-genome`. The file locations would then be provided via STDOUT.

Using ggd list-files
--------------------
Use :code:`ggd list-files` to list the files associated with a previously installed ggd package.
Running :code:`ggd list-files -h` will give you the following message:

list-files arguments: 

-h, --help                                      show this help message and exit

/name                                           (Positional) Pattern to match recipe name(s). Ex:
                                                `ggd list-files "hg19-hello*" -s "Homo_sapiens" -g "hg19" -p "out*"`
                                                ('/' indicates a placeholder and is not part of the argument name)

-c , --channel                                  (Optional) The ggd channel of the recipe to find. (Default = genomics)

-s, --species                                   (Optional) species recipe is for. Use '*' for any species

-g GENOME_BUILD, --genome-build GENOME_BUILD    (Optional) genome build the recipe is for. Use '*' for any
                                                genome build.

-v VERSION, --version VERSION                   (Optional) pattern to match the version of the file desired.
                                                Use '*' for any version.

-p PATTERN, --pattern PATTERN                   (Optional) pattern to match the name of the file desired. To
                                                list all files for a ggd package, do not use the -p option.


Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments: 

* *name:* The :code:`name` field is required and represents the ggd data package name for which to list files.

Optional arguments for filtering:

* *-c:* The :code:`-c` flag is used to set the ggd channel (default: genomics).

* *-s:* The :code:`-s` flag represents the species of the ggd data package and filters files based on species.

* *-g:* The :code:`-g` flag represents the genome-build of the ggd data package and filters the list to the specified build.

* *-v:* The :code:`-v` flag represents the ggd data package version. This flag helps to refine the package to a specific version.

* *-p:* The :code:`-p` flag is used to list files that have a specific pattern, such as '\*.fai' or '\*.bam'.


The **name** field is the only required parameter for :code:`ggd list-files`, however, the other flags are provided to help reduce the
search space and refine the final file list.

Examples
--------

1. Simple example with only the name field
++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd list-files grch37-reference-genome

      <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome/1/hs37d5.fa.fai
      <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome/1/hs37d5.fa

2. Example using the ``-s``, ``-g``, and ``-p`` flags to find the gzipped vcf files for a given ggd data package
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd list-files grch37-esp-variants -s Homo_sapiens -g GRCh37 -p *.vcf.gz

     <conda root>/ggd/Homo_sapiens/GRCh37/grch37-esp-variants/1/ESP6500SI.all.snps_indels.tidy.vcf.gz


    $ ggd list-files grch37-esp-variants -s Homo_sapiens -g GRCh37 -p *.vcf.gz.tbi

     <conda root>/ucgd/lustre/work/u1138933/anaconda2/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants/1/ESP6500SI.all.snps_indels.tidy.vcf.gz.tbi


.. note::

    ``<conda root>`` represents the root directory for the local conda repository on your system.
