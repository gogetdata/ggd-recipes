.. _ggd-pkg-info:

ggd pkg-info
============

[:ref:`Click here to return to the home page <home-page>`]

ggd pkg-info is used to get package information for a specific ggd data package installed on your system.

Using ggd pkg-info
------------------
pkg-info is useful when you want to know a bit more about the data package you have installed. This tool
provides general information about the data package and can access the original recipe used to download
and process the data.

.. note::

    The ggd data package must be installed on your system in order to get the package information.


Running :code:`ggd pkg-info -h` will give you the following help message:

pkg-info arguments:

-h, --help              show this help message and exit

/name                   (Positional) The name of the recipe to get info about.
                        ('/' indicates a placeholder and is not part of the argument name) 

-c, --channel           (Optional) The ggd channel of the recipe to list info about (default: genomics)

-av, --all_versions     (Optional) When the flag is set, list all ggd versions of a
                        ggd-recipe for a specific ggd-channel. (NOTE: -av flag does not
                        accept arguments)

-sr, --show_recipe      (Optional) When the flag is set, the recipe will be printed to the
                        stdout. This will provide info on where the data is hosted and how
                        it was processed. (NOTE: -sr flag does not accept arguments)

Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *name:* The :code:`name` argument represents the name of the ggd data package for which to retrieve info.
  No flag is required for this argument, just supply the name.

Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel the package came from. The default is genomics.

* *-av:* The :code:`-av` flag is used to list *all available* versions of the ggd package. Not all versions
  will be installed on your system. This flag only needs to be set and will not accept additional arguments.

* *-sr:* The :code:`-sr` flag is used to *show the recipe* for the data package. Showing the recipe will allow
  the user to identify where the data was originally downloaded, how it was processed, and other information
  about the data being used.

If the package has not been installed on your system then the package info will not be displayed and the recipe will not be accessible.
However, you can use the -av flag to list all of the available versions.

Examples
--------

1. Example listing pkg info:
++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd pkg-info hg19-phastcons-ucsc-v1

      GGD-Recipe: hg19-phastcons-ucsc-v1
      GGD-Channel: genomics
      Summary: phastCons scores for MSA of 99 genomes to hg19
      Pkg Version: 1
      Pkg Build: 0
      Species: Homo_sapiens
      Genome Build: hg19
      Keywords: ['phastCons', 'conservation']
      Data Version: 09-Feb-2014
      Build Requirements: []
      Run Requirements: []
      Pkg File Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1
      Pkg Files: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1/hg19.100way.phastCons.bw

2. Example listing pkg info and all available versions:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd pkg-info hg19-phastcons-ucsc-v1 -av

      GGD-Recipe: hg19-phastcons-ucsc-v1
      GGD-Channel: genomics
      Summary: phastCons scores for MSA of 99 genomes to hg19
      Pkg Version: 1
      Pkg Build: 0
      Species: Homo_sapiens
      Genome Build: hg19
      Keywords: ['phastCons', 'conservation']
      Data Version: 09-Feb-2014
      Build Requirements: []
      Run Requirements: []
      Pkg File Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1
      Pkg Files: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-phastcons-ucsc-v1/1/hg19.100way.phastCons.bw


      Listing all ggd-recipe version for the hg19-phastcons-ucsc-v1 recipe in the ggd-genomics channel

        Loading channels: ...working... done
        - # Name                       Version      Build  Channel
        - hg19-phastcons-ucsc-v1             1          0  ggd-genomics
        - hg19-phastcons-ucsc-v1             1          1  ggd-genomics
        - hg19-phastcons-uscs-v1             1          2  ggd-genomics
        - hg19-phastcons-uscs-v1             2          0  ggd-genomics
        - hg19-phastcons-ucsc-v1             3          0  ggd-genomics

3. Example listing pkg info and recipe:
+++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd pkg-info hg19-repeatmasker-ucsc-v1 -sr

      GGD-Recipe: hg19-repeatmasker-ucsc-v1
      GGD-Channel: genomics
      Summary: RepeatMasker track from UCSC
      Pkg Version: 1
      Pkg Build: 0
      Species: Homo_sapiens
      Genome Build: hg19
      Keywords: ['rmsk', 'region']
      Data Version: 27-Apr-2009
      Build Requirements: ['gsort', 'htslib', 'zlib']
      Run Requirements: ['gsort', 'htslib', 'zlib']
      Pkg File Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-repeatmasker-uscs-v1/1
      Pkg Files: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-repeatmasker-ucsc-v1/1/rmsk.bed.gz, <conda root>/share/ggd/Homo_sapiens/hg19/hg19-repeatmasker-ucsc-v1/1/rmsk.bed.gz.tbi


      hg19-repeatmasker-ucsc-v1 recipe file:
      *****************************************************************
      * #!/bin/sh
      * set -eo pipefail -o nounset
      * genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg19/hg19.genome
      * wget --quiet -O - http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database/rmsk.txt.gz \
      * | gzip -dc \
      * | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend\tfamily_class_name\tdiv+del+ins\tstrand"} {print $6,$7,$8,$12"_"$13"_"$11,$3+$4+$5,$10}' \
      * | gsort /dev/stdin $genome \
      * | bgzip -c > hg19-repeatmasker-ucsc-v1.bed.gz
      *
      * tabix hg19-repeatmasker-ucsc-v1.bed.gz
      *
      *****************************************************************
      NOTE: The recipe provided above outlines where the data was accessed and how it was processed
