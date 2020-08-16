.. _ggd-pkg-info:

ggd pkg-info
============

[:ref:`Click here to return to the home page <home-page>`]

:code:`ggd pkg-info` is used to get package information for a specific ggd data package installed on your system.

This is a great resource for identifying the information for a specific ggd data package installed on your system. 
It will provide information about the data type, the provider of the data, the actual version of the data, the 
version of the ggd data package, and more. 

The examples below help to illustrate what is available from :code:`ggd pkg-info`. 

This tool provides a resource to help enforce reproducibility. The information provide from running 
:code:`ggd pkg-info` will help to distinguish the data package and allow you to provide such information to 
other or in a citation

Using ggd pkg-info
------------------
pkg-info is useful when you want to know a bit more about the data package you have installed. This tool
provides general information about the data package and can access the original recipe used to download
and process the data.

.. note::

    The ggd data package must be installed on your system in order to get the package information


Running :code:`ggd pkg-info -h` will give you the following help message:

pkg-info arguments:


+---------------------+-----------------------------------------------------------------------------------+
| pkg-info            | Get the information for a specific ggd data package installed in the current      |
|                     | conda environment                                                                 |
+=====================+===================================================================================+
| -h, --help          | show this help message and exit                                                   |
+---------------------+-----------------------------------------------------------------------------------+
| name                | **Required** The name of the recipe to get info about.                            |
+---------------------+-----------------------------------------------------------------------------------+
| -c, --channel       | (Optional) The ggd channel of the recipe to list info about (default: genomics)   |
+---------------------+-----------------------------------------------------------------------------------+
| -sr, --show_recipe  | (Optional) When the flag is set, the recipe will be printed to the                |
|                     | stdout. This will provide info on where the data is hosted and how                |
|                     | it was processed. (NOTE: -sr flag does not accept arguments)                      |
+---------------------+-----------------------------------------------------------------------------------+

Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *name:* The :code:`name` argument represents the name of the ggd data package for which to retrieve info.
  No flag is required for this argument, just supply the name.

Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel the package came from. The default is genomics.

* *-sr:* The :code:`-sr` flag is used to *show the recipe* for the data package. Showing the recipe will allow
  the user to identify where the data was originally downloaded, how it was processed, and other information
  about the data being used.

If the package has not been installed on your system then the package info will not be displayed and the recipe will not be accessible.

Examples
--------

1. Example listing pkg info:
++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd pkg-info hg19-gaps-ucsc-v1 

      ----------------------------------------------------------------------------------------------------

        GGD-Package: hg19-gaps-ucsc-v1

        GGD-Channel: ggd-genomics

        GGD Pkg Version: 1

        Summary: Assembly gaps from UCSC in bed format

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: gaps, region, bed-file

        Cached: uploaded_to_aws

        Data Version: 27-Apr-2009

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
		  hg19-gaps-ucsc-v1.bed.gz
		  hg19-gaps-ucsc-v1.bed.gz.tbi

        Approximate Data File Sizes:
		  hg19-gaps-ucsc-v1.bed.gz: 5.16K
		  hg19-gaps-ucsc-v1.bed.gz.tbi: 8.22K

        Pkg File Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1

        Installed Pkg Files: 
          <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1/hg19-gaps-ucsc-v1.bed.gz.tbi
          <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1/hg19-gaps-ucsc-v1.bed.gz

      ---------------------------------------------------------------------------------------------------- 

2. Example listing pkg info and recipe:
+++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd pkg-info hg19-gaps-ucsc-v1 -sr


      ----------------------------------------------------------------------------------------------------

        GGD-Package: hg19-gaps-ucsc-v1

        GGD-Channel: ggd-genomics

        GGD Pkg Version: 1

        Summary: Assembly gaps from UCSC in bed format

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: gaps, region, bed-file

        Cached: uploaded_to_aws

        Data Version: 27-Apr-2009

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
		  hg19-gaps-ucsc-v1.bed.gz
		  hg19-gaps-ucsc-v1.bed.gz.tbi

        Approximate Data File Sizes:
		  hg19-gaps-ucsc-v1.bed.gz: 5.16K
		  hg19-gaps-ucsc-v1.bed.gz.tbi: 8.22K

        Pkg File Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1

        Installed Pkg Files: 
          <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1/hg19-gaps-ucsc-v1.bed.gz.tbi
          <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1/hg19-gaps-ucsc-v1.bed.gz

      ---------------------------------------------------------------------------------------------------- 



      hg19-gaps-ucsc-v1 recipe file:
      *****************************************************************************
      * #!/bin/sh
      * set -eo pipefail -o nounset
      * genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
      * wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/gap.txt.gz \
      * | gzip -dc \
      * | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tsize\ttype\tstrand"} {print $2,$3,$4,$7,$8,"+"}' \
      * | gsort /dev/stdin $genome \
      * | bgzip -c > hg19-gaps-ucsc-v1.bed.gz
      * 
      * tabix hg19-gaps-ucsc-v1.bed.gz
      *****************************************************************************
      :ggd:pkg-info: NOTE: The recipe provided above outlines where the data was accessed and how it was processed





