.. _ggd-get-files:

ggd get-files
==============

[:ref:`Click here to return to the home page <home-page>`]

The :code:`ggd get-files` command is used to get/list the files associated with a ggd data package that has been installed on your system
using :code:`ggd install`.

.. note::

    If the data package has not been installed on your system :code:`ggd get-files` will not be able to list the files.


This tool is used to find the location of a file(s) downloaded using ggd. For example, if you downloaded the GRCh37
reference genome using :code:`ggd install grch37-reference-genome-ensembl-v1` and you want the fasta file and the fai file you would
run :code:`ggd get-files grch37-reference-genome-ensembl-v1`. The file locations would then be provided via STDOUT.

Using ggd get-files
--------------------
Use :code:`ggd get-files` to list the files associated with a previously installed ggd package.
Running :code:`ggd get-files -h` will give you the following message:


get-files arguments: 

+----------------------------------------------+------------------------------------------------------------------------------------+
| get-files                                    | Get a list of file(s) for a specific installed ggd package                         |
+==============================================+====================================================================================+
| ``-h``, ``--help``                           | show this help message and exit                                                    |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``name``                                     | **Required**  recipe name                                                          |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``-c``, ``--channel``                        | (Optional) The ggd channel of the recipe to find. (Default = genomics)             |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``-s``, ``--species``                        | (Optional) species recipe is for. Use '*' for any species                          |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``-g`` , ``--genome-build``                  | (Optional) genome build the recipe is for. Use '*' for any genome build.           |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``-v``, ``--version``                        | (Optional) pattern to match the version of the file desired.                       |
|                                              | Use '*' for any version                                                            |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``-p``, ``--pattern``                        | (Optional) pattern to match the name of the file desired. To                       |
|                                              | list all files for a ggd package, do not use the -p option.                        |
+----------------------------------------------+------------------------------------------------------------------------------------+
| ``--prefix``                                 | (Optional) The name or the full directory path to an                               |      
|                                              | conda environment where a ggd recipe is stored. (Only                              |
|                                              | needed if not getting file paths for files in the                                  |
|                                              | current conda environment)                                                         |
+----------------------------------------------+------------------------------------------------------------------------------------+

.. note::
  
    :code:`ggd get-files` can be used in a script that uses a data package. This usually means you use the :code:`-p` flag to 
    get a specific pattern. See :ref:`example 3 below <ggd-get-files-example-3>` for an example of how to use the output. 


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

* *--prefix:* The :code:`--prefix` flag is used to designate which conda environment/prefix to get the file from. 
  **This allows one to store ggd data packages in one environment and access it from another.**


The **name** field is the only required parameter for :code:`ggd get-files`, however, the other flags are provided to help reduce the
search space and refine the final file list.

Examples
--------

1. Simple example with only the name field
++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd get-files grch37-reference-genome-1000g-v1

      <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome-1000g-v1/1/hs37d5.fa.fai
      <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-reference-genome-1000g-v1/1/hs37d5.fa

2. Example using the ``-s``, ``-g``, and ``-p`` flags to find the gzipped vcf files for a given ggd data package
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd get-files grch37-esp-variants-uw-v1 -s Homo_sapiens -g GRCh37 -p *.vcf.gz

     <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants-uw-v1/1/grch37-esp-variants-uw-v1.vcf.gz


    $ ggd get-files grch37-esp-variants-uw-v1 -s Homo_sapiens -g GRCh37 -p *.vcf.gz.tbi

     <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants-uw-v1/1/ESP6500SI.all.snps_indels.tidy.vcf.gz.tbi


.. note::

    ``<conda root>`` represents the root directory for the local conda repository on your system.


3. Example of using the :code:`--prefix` flag to get data files from a different conda environment
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:code:`ggd get-files` allows one to access ggd data packages stored in different conda environments using the :code:`--prefix` flag. 
In this example we are going to:

  A) Get the files for the ggd data package :code:`grch37-eiee-genes-ostrander-v1` stored in the conda environment :code:`data:`

  B) From the :code:`grch37-eiee-genes-ostrander-v1` ggd data package in the :code:`data` conda environment, get 
     the :code:`grch37-eiee-genes-ostrander-v1.bed.gz` file only. 

  C) Get the :code:`grch37-eiee-genes-ostrander-v1.bed.gz` data file as in B, but use a wild card within the :code:`-p` pattern flag 

A)
 

.. code-block:: bash


  $ ggd get-files grch37-eiee-genes-ostrander-v1 --prefix data

    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.bed.gz.tbi
    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.complement.bed.gz.tbi
    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.bed.gz
    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.complement.bed.gz

B)

.. code-block:: bash


  $ ggd get-files grch37-eiee-genes-ostrander-v1 --prefix data -p grch37-eiee-genes-ostrander-v1.bed.gz

    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.bed.gz

C)

.. code-block:: bash


  $ ggd get-files grch37-eiee-genes-ostrander-v1 --prefix data -p *v1.bed.gz

    <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1/1/grch37-eiee-genes-ostrander-v1.bed.gz




.. _ggd-get-files-example-4:

4. Use the output of the get-files command as input to a shell command
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Installing data is one necessary part of genomic data management, however, using the data is the vital part. Therefore, 
the :code:`ggd get-files` command was developed to provide easy access and use to the installed ggd data packages. 
Simply stated, :code:`ggd get-files` can be used to access a desired file from an installed ggd data package in a command,
in a script, as a parameter, etc. 

**In order to use a data file you will need to use the** :code:`-p` **flag in order to get a single file as an output.**

.. note::
  
    If you are in the conda package where the data is stored you can use the environment variables created for each data
    package as another way to access the files. (To see the available environment variables for the active conda environment 
    run :code:`ggd show-env` or :code:`ggd list`) If the data you are accessing is stored in a different conda environment then
    the data environment variables will not be available for use. You will need to use :code:`ggd get-files` with the 
    :code:`--prefix` flag set (See example 3 above). 


A) Assigning the path to an environment variable and using it in the shell. 
  
  Here we will get and use the :code:`.bed.gz` file from the :code:`hg19-cpg-islands-ucsc-v1` ggd data packages

  .. code::

      $ cpg_islands="$(ggd get-files hg19-cpg-islands-ucsc-v1 -p *.bed.gz)"


  To check that the file is in this new variable called :code:`cpg_islands` run:

  .. code::

      $ echo $cpg_islands

  You can now use this cpg_islands variable in a script. 

  1) Use tabix to get CpG info for a specific genomic region

    .. code::

        $ tabix $cpg_islands chr6:150284682-152129771

          chr6  150284682 150286515 CpG: 196
          chr6  150311256 150312369 CpG: 85
          chr6  150326011 150326802 CpG: 67
          chr6  150335525 150336278 CpG: 64
          chr6  150358872 150359394 CpG: 51
          chr6  150378838 150379048 CpG: 16
          chr6  150389943 150390558 CpG: 55
          chr6  150463771 150465002 CpG: 127
          chr6  150920904 150922146 CpG: 129
          chr6  151186747 151188112 CpG: 151
          chr6  151412003 151412339 CpG: 25
          chr6  151560766 151560993 CpG: 16
          chr6  151561283 151562550 CpG: 132
          chr6  151646668 151646958 CpG: 25
          chr6  151662605 151663056 CpG: 42
          chr6  151711094 151712829 CpG: 195
          chr6  151773043 151774070 CpG: 96
          chr6  151814980 151815527 CpG: 64
          chr6  152128822 152129771 CpG: 89


  2) You can subset a vcf file by cpg island regions using bedtools
  
    .. code::

        $ bedtools intersect -a <your-vcf-file> -b $cpg_islands -wa > vcf_file_cpg_subset.vcf


  3) And many other options you could think of...

B) Piping the output from :code:`ggd get-files` to a command

  Usinsg the example above of subsetting a vcf file by the cpg island regions using bedtools 

  .. code::

      ggd get-files hg19-cpg-islands-ucsc-v1 -p *.bed.gz \
        | bedtools intersect -a <your-vcf-file> -b - -wa > vcf_file_cpg_subset.vcf


There are many other ways not listed here to use get-files to use the installed ggd data files in a script, shell command, 
workflow, etc. 

If your data is stored in a different conda environment you could easily add the :code:`--prefix` flag to 
the command. 

If you have examples you would like added or you would like to share, let us know and we can add it to the docs. 











