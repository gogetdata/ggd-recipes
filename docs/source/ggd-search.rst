.. _ggd-search:

ggd search
==========

[:ref:`Click here to return to the home page <home-page>`]

ggd search is used to search for a data package stored within the ggd ecosystem. It is dependent on the ggd channel
provided.


Using ggd search
----------------
Once ggd is installed on your system you can run :code:`ggd search` to search for available data packages.
Running :code:`ggd search -h` will give you the a similar help message as below:

Search arguments: 

+--------------------------+---------------------------------------------------------------------------------------------------+
| ggd search               | Search for available ggd data packages. Results are filtered by match score from high to low.     | 
|                          | (Only 5 results will be reported unless the -dn flag is changed)                                  |
+==========================+===================================================================================================+
| -h, --help               | show this help message and exit                                                                   |
+--------------------------+---------------------------------------------------------------------------------------------------+
| search_term              | **Required** The term(s) to search for. Multiple terms can be used. Example:                      |
| (Positional Argument)    | 'ggd search reference genome', where "reference" and "genome" are the search terms                |
+--------------------------+---------------------------------------------------------------------------------------------------+
| -g, --genome_build       | (Optional) Filter results by the genome build of the desired recipe                               |
+--------------------------+---------------------------------------------------------------------------------------------------+
| -s, --species            | (Optional) Filter results by the species for the desired recipe                                   |
+--------------------------+---------------------------------------------------------------------------------------------------+
| -dn, --display-number    | (Optional) The number of search results to display. (Default = 5)                                 |
+--------------------------+---------------------------------------------------------------------------------------------------+
| -m, --match_score        | (Optional) A score between 0 and 100 to use to filter the results by. (Default = 75).             |
|                          | The lower the number the more results will be output"                                             |
+--------------------------+---------------------------------------------------------------------------------------------------+
| -c, --channel            | (Optional) The ggd channel to search. (Default = genomics)                                        |
+--------------------------+---------------------------------------------------------------------------------------------------+

Any combination of search terms can be used to search for a package. 

Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *search_term:* The :code:`search_term` is a positional argument that represents the "terms" to search for. At least one search term is required, but multiple can be provided 
  **NOTE: You do not need to add the keyword** :code:`search_term`. 

.. note::

    If the genome build or the species is added to the search terms the results will be filtered based on the species and/or genome build provided. (The genome build and/or species 
    need to be spelled the same as the choices for the :code:`-g` or :code:`-s` flags

Optional arguments:

* *-g:* The :code:`-g` flag is used to filter the search results on a specific "genome build". This flag is not required, however, if 
  provided the resulting search will be filtered to only include data packages with that genome build.
* *-s:* The :code:`-s` flag is used to filter the search results on a specific "species". Only data packages for that specific species 
  will be displayed.
* *-dn:* The :code:`-dn` flag is used to filter the search results based on the number of results to display. Default = 5. If more than 
  5 results are available and you don't see the desired package in the results list, add the :code:`-dn {N}` flag where *N* is the number 
  of results to show. 
* *-m:* The :code:`-m` flag represents the "match" score to use for searching. A fuzzy word match is used to identify similar packages
  to the terms search for, and the match score defines which packages will be displayed based on a cutoff. A default match score
  cutoff is provided, but this flag can be used to provide more strict or more lenient search results. (Default = 75)
* *-c:* The :code:`-c` flag is used to set the ggd channel to search in. The *genomics* channel is set by default.




  .. note::
  
      There is no limit to the number of search terms you can use. However, the more search terms used will result in an increase in the number of results returned. 

      Additionally, the genome build or species can be used as a search term. If they are spelled correctly, regardless of case, the results will be filtered by that genome 
      build and/or species. If a genome build or species is added as a search term and is not spelled correctly the results will NOT be filtered by the intended genome build
      and/or species. 



Example
-------
Some examples of using the `ggd search` tool:

1. Simple example with one search term:
+++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd search reference


      ----------------------------------------------------------------------------------------------------

        mm10-reference-ucsc-v1
        ======================

        Summary: Reference genome for mouse from UCSC

        Species: Mus_musculus

        Genome Build: mm10

        Keywords: reference, ucsc, mouse, mm10, reference-genome, fasta-file

        Data Version: 07-Feb-2012


        To install run:
            ggd install mm10-reference-ucsc-v1

      ----------------------------------------------------------------------------------------------------

        hg19-reference-genome-ucsc-v1
        =============================

        Summary: The hg19 soft masked genomic DNA seqeunce reference genome from UCSC (patch 13). Repeats found by 'RepeatMasker' and 'Tandem Repeat Finder' are shown as lower case. Non repeating seqeunce are shown as upper case.

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: ref, reference-genome, fasta-file, soft-masked

        Data Provider: UCSC

        Data Version: 17-Jan-2020

        File type(s): fa

        Data file coordinate base: NA

        Included Data Files:
            hg19-reference-genome-ucsc-v1.fa.gz
            hg19-reference-genome-ucsc-v1.fa.gz.fai
            hg19-reference-genome-ucsc-v1.fa.gz.gzi

        Approximate Data File Sizes:
            hg19-reference-genome-ucsc-v1.fa.gz: 997.23M
            hg19-reference-genome-ucsc-v1.fa.gz.fai: 12.23K
            hg19-reference-genome-ucsc-v1.fa.gz.gzi: 808.71K


        To install run:
            ggd install hg19-reference-genome-ucsc-v1

      ----------------------------------------------------------------------------------------------------

        hg38-reference-genome-ucsc-v1
        =============================

        Summary: The hg38 soft masked genomic DNA seqeunce reference genome from UCSC (patch 12). Repeats found by 'RepeatMasker' and 'Tandem Repeat Finder' are shown as lower case. Non repeating seqeunce are shown as upper case.

        Species: Homo_sapiens

        Genome Build: hg38

        Keywords: ref, reference-genome, fasta-file, soft-masked

        Data Provider: UCSC

        Data Version: 10-Aug-2018

        File type(s): fa

        Data file coordinate base: NA

        Included Data Files:
            hg38-reference-genome-ucsc-v1.fa.gz
            hg38-reference-genome-ucsc-v1.fa.gz.fai
            hg38-reference-genome-ucsc-v1.fa.gz.gzi

        Approximate Data File Sizes:
            hg38-reference-genome-ucsc-v1.fa.gz: 1.02G
            hg38-reference-genome-ucsc-v1.fa.gz.fai: 25.61K
            hg38-reference-genome-ucsc-v1.fa.gz.gzi: 814.34K


        To install run:
            ggd install hg38-reference-genome-ucsc-v1

      ----------------------------------------------------------------------------------------------------

        grch37-reference-genome-1000g-v1
        ================================

        Summary: GRCh37 reference genome from 1000 genomes

        Species: Homo_sapiens

        Genome Build: GRCh37

        Keywords: ref, reference, fasta-file

        Data Version: phase2_reference


        To install run:
            ggd install grch37-reference-genome-1000g-v1

      ----------------------------------------------------------------------------------------------------

        hg19-reference-genome-gencode-v1
        ================================

        Summary: The GRCh37 DNA nucleotide sequence primary assembly. Sequence regions include reference chromsomes and scaffoldings. Mapped to hg19

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: Reference-Genome, Fasta, DNA-Sequence, GENCODE-34, Fasta-sequence, primary-assemlby

        Data Provider: GENCODE

        Data Version: release-34

        File type(s): fa

        Data file coordinate base: NA

        Included Data Files:
            hg19-reference-genome-gencode-v1.fa.gz
            hg19-reference-genome-gencode-v1.fa.gz.fai
            hg19-reference-genome-gencode-v1.fa.gz.gzi

        Approximate Data File Sizes:
            hg19-reference-genome-gencode-v1.fa.gz: 881.99M
            hg19-reference-genome-gencode-v1.fa.gz.fai: 2.82K
            hg19-reference-genome-gencode-v1.fa.gz.gzi: 772.92K


        To install run:
            ggd install hg19-reference-genome-gencode-v1

      ----------------------------------------------------------------------------------------------------


      :ggd:search: NOTE  Only showing results for top 5 of 30 matches.
      :ggd:search: To display all matches append your search command with '-dn 30'

           ggd search reference -dn 30




2. Simple example with two search terms:
++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd search chrom sizes


      ----------------------------------------------------------------------------------------------------

        hg19-chromsizes-ggd-v1
        ======================

        Summary: Chromosome lengths for hg19

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: genome, chromosome, lengths, sizes

        Data Provider: GGD

        Data Version: 16-Apirl-2020

        File type(s): txt

        Data file coordinate base: NA

        Included Data Files: 
            hg19-chromsizes-ggd-v1.txt

        Approximate Data File Sizes: 
            hg19-chromsizes-ggd-v1.txt: 1.99K


        To install run:
            ggd install hg19-chromsizes-ggd-v1

      ----------------------------------------------------------------------------------------------------

        hg38-chromsizes-ggd-v1
        ======================

        Summary: Chromosome lengths for hg38

        Species: Homo_sapiens

        Genome Build: hg38

        Keywords: genome, chromosome, lengths, sizes

        Data Provider: GGD

        Data Version: 16-Apirl-2020

        File type(s): txt

        Data file coordinate base: NA

        Included Data Files: 
            hg38-chromsizes-ggd-v1.txt

        Approximate Data File Sizes: 
            hg38-chromsizes-ggd-v1.txt: 15.53K


        To install run:
            ggd install hg38-chromsizes-ggd-v1

      ----------------------------------------------------------------------------------------------------

        grch37-chromsizes-ggd-v1
        ========================

        Summary: Chromosome lengths for GRCh37

        Species: Homo_sapiens

        Genome Build: GRCh37

        Keywords: genome, chromosome, lengths, sizes

        Data Provider: GGD

        Data Version: 16-Apirl-2020

        File type(s): txt

        Data file coordinate base: NA

        Included Data Files:
            grch37-chromsizes-ggd-v1.txt

        Approximate Data File Sizes:
            grch37-chromsizes-ggd-v1.txt: 5.17K


        To install run:
            ggd install grch37-chromsizes-ggd-v1

      ----------------------------------------------------------------------------------------------------

      	grch38-chromsizes-ggd-v1
        ========================

        Summary: Chromosome lengths for GRCh38

        Species: Homo_sapiens

        Genome Build: GRCh38

        Keywords: genome, chromosome, lengths, sizes

        Data Provider: GGD

        Data Version: 16-April-2020

        File type(s): txt

        Data file coordinate base: NA

        Included Data Files:
            grch38-chromsizes-ggd-v1.txt

        Approximate Data File Sizes:
            grch38-chromsizes-ggd-v1.txt: 11.14K


        To install run:
            ggd install grch38-chromsizes-ggd-v1

      ----------------------------------------------------------------------------------------------------



3. Simple example with the genome build as a search term:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd search repeat masker hg19

      ----------------------------------------------------------------------------------------------------

        hg19-repeatmasker-ucsc-v1
        =========================

        Summary: RepeatMasker track from UCSC in bed format. Interspersed repeats and low complexity sequences identified using the RepeatMasker program. Scaffoldings missing from the GGD hg19.genome file are removed.

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: rmsk, region, low-complexity-repeats, SINE, ALUs, LINE, LTR, DNA-repeat-elements, simple-repeats, RNA-repeats

        Data Provider: UCSC

        Data Version: 22-Mar-2020

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            hg19-repeatmasker-ucsc-v1.bed.gz
            hg19-repeatmasker-ucsc-v1.bed.gz.tbi

        Approximate Data File Sizes:
            hg19-repeatmasker-ucsc-v1.bed.gz: 114.62M
            hg19-repeatmasker-ucsc-v1.bed.gz.tbi: 526.98K


        To install run:
            ggd install hg19-repeatmasker-ucsc-v1

      ----------------------------------------------------------------------------------------------------

        hg19-simple-repeats-ucsc-v1
        ===========================

        Summary: Simple repeats track from UCSC. Simple tandem repeats and imperfect repeats identified by the Tandem Repeats Finder (TRF) algorithm. Any scaffoldings not in the hg19.genome file are removed from the final file

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: simrep, simple-repeats, repeats, tandem-repeats, simple-tandem-repeats

        Data Provider: UCSC

        Data Version: 22-Mar-2020

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            hg19-simple-repeats-ucsc-v1.bed.gz
            hg19-simple-repeats-ucsc-v1.bed.gz.tbi

        Approximate Data File Sizes:
            hg19-simple-repeats-ucsc-v1.bed.gz: 25.58M
            hg19-simple-repeats-ucsc-v1.bed.gz.tbi: 1.35M


        To install run:
            ggd install hg19-simple-repeats-ucsc-v1

      ----------------------------------------------------------------------------------------------------



4. Example using ``-g`` and ``-s`` flags to filter the results:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd search autosomal-dominant  -g GRCh37 -s Homo_sapiens

      ----------------------------------------------------------------------------------------------------

        grch37-autosomal-dominant-genes-berg-v1
        =======================================

        Summary: CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes (as of June 2011) deemed to follow autosomal dominant inheritance. (Assembled by Macarthur Lab). Berg et al, 2013:  (https://www.ncbi.nlm.nih.gov/pubmed/22995991).

        Species: Homo_sapiens

        Genome Build: GRCh37

        Keywords: genes, autosomal-dominant, disease, Berg_et_al, AD, OMIM, gene_coordinates, CDS-regions

        Data Provider: berg

        Data Version: 1-15-2013

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            grch37-autosomal-dominant-genes-berg-v1.bed.gz
            grch37-autosomal-dominant-genes-berg-v1.bed.gz.tbi
            grch37-autosomal-dominant-genes-berg-v1.compliment.bed.gz
            grch37-autosomal-dominant-genes-berg-v1.compliment.bed.gz.tbi

        Approximate Data File Sizes:
            grch37-autosomal-dominant-genes-berg-v1.bed.gz: 119.97K
            grch37-autosomal-dominant-genes-berg-v1.bed.gz.tbi: 27.12K
            grch37-autosomal-dominant-genes-berg-v1.compliment.bed.gz: 73.13K
            grch37-autosomal-dominant-genes-berg-v1.compliment.bed.gz.tbi: 20.39K


        To install run:
            ggd install grch37-autosomal-dominant-genes-berg-v1

      ----------------------------------------------------------------------------------------------------

        grch37-autosomal-dominant-genes-blekhman-v1
        ===========================================

        Summary: CDS region genomic coordinates, along with the compliment coordinates, for OMIM disease genes deemed  to follow autosomal dominant inheritance according to extensive manual curation by Molly Przeworski's group.(https://www.ncbi.nlm.nih.gov/pubmed/18571414).

        Species: Homo_sapiens

        Genome Build: GRCh37

        Keywords: genes, autosomal-dominant, disease, Blekhman_et_al, AD, OMIM, gene_coordinates, CDS-regions

        Data Provider: blekhman

        Data Version: 6-24-2008

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            grch37-autosomal-dominant-genes-blekhman-v1.bed.gz
            grch37-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi
            grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz
            grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi

        Approximate Data File Sizes:
            grch37-autosomal-dominant-genes-blekhman-v1.bed.gz: 59.94K
            grch37-autosomal-dominant-genes-blekhman-v1.bed.gz.tbi: 15.15K
            grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz: 38.45K
            grch37-autosomal-dominant-genes-blekhman-v1.compliment.bed.gz.tbi: 15.37K


        To install run:
            ggd install grch37-autosomal-dominant-genes-blekhman-v1

      ----------------------------------------------------------------------------------------------------

        grch37-autosomal-dominant-genes-berg-blekhman-v1
        ================================================

        Summary: CDS region genomic coordinates, along with the compliment coordinates, for combined set of OMIM disease genes deemed to follow autosomal dominant inheritance. (Assembled by Macarthur Lab). Gene sets from:  Berg et al, 2013:  (https://www.ncbi.nlm.nih.gov/pubmed/22995991). Blekham et al, 2008: (https://www.ncbi.nlm.nih.gov/pubmed/18571414)

        Species: Homo_sapiens

        Genome Build: GRCh37

        Keywords: genes, autosomal-dominant, disease, Berg_et_al, Blekhman_et_al, AD, OMIM, gene_coordinates, CDS-regions

        Data Provider: berg-blekhman

        Data Version: 1-15-2013_6-24-2008

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            grch37-autosomal-dominant-genes-berg-blekhman-v1.bed.gz
            grch37-autosomal-dominant-genes-berg-blekhman-v1.bed.gz.tbi
            grch37-autosomal-dominant-genes-berg-blekhman-v1.compliment.bed.gz
            grch37-autosomal-dominant-genes-berg-blekhman-v1.compliment.bed.gz.tbi

        Approximate Data File Sizes:
            grch37-autosomal-dominant-genes-berg-blekhman-v1.bed.gz: 135.22K
            grch37-autosomal-dominant-genes-berg-blekhman-v1.bed.gz.tbi: 29.55K
            grch37-autosomal-dominant-genes-berg-blekhman-v1.compliment.bed.gz: 83.03K
            grch37-autosomal-dominant-genes-berg-blekhman-v1.compliment.bed.gz.tbi: 21.44K


        To install run:
            ggd install grch37-autosomal-dominant-genes-berg-blekhman-v1

      ----------------------------------------------------------------------------------------------------


5. Example of searching for two different data packages at the same time for a specific genome build
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd search pfam cpg hg19

      ----------------------------------------------------------------------------------------------------

        hg19-pfam-domains-ucsc-v1
        =========================

        Summary: High quality, manually curated Pfam domain annotation in bed12 format from UCSC

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: pfam, domains, protein, protein-domains, UCSC

        Data Provider: UCSC

        Data Version: 16-Apr-2017

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            hg19-pfam-domains-ucsc-v1.bed12.bed.gz
            hg19-pfam-domains-ucsc-v1.bed12.bed.gz.tbi

        Approximate Data File Sizes:
            hg19-pfam-domains-ucsc-v1.bed12.bed.gz: 1.41M
            hg19-pfam-domains-ucsc-v1.bed12.bed.gz.tbi: 143.50K


        To install run:
            ggd install hg19-pfam-domains-ucsc-v1

      ----------------------------------------------------------------------------------------------------

        hg19-cpg-islands-ucsc-v1
        ========================

        Summary: cpg islands from UCSC in bed format. Scaffoldings that are not contained in the hg19.genome file are removed

        Species: Homo_sapiens

        Genome Build: hg19

        Keywords: CpG, region, bed-file, cpg-islands, islands

        Data Provider: UCSC

        Data Version: 22-Mar-2020

        File type(s): bed

        Data file coordinate base: 0-based-inclusive

        Included Data Files:
            hg19-cpg-islands-ucsc-v1.bed.gz
            hg19-cpg-islands-ucsc-v1.bed.gz.tbi

        Approximate Data File Sizes:
            hg19-cpg-islands-ucsc-v1.bed.gz: 621.35K
            hg19-cpg-islands-ucsc-v1.bed.gz.tbi: 186.06K


        To install run:
            ggd install hg19-cpg-islands-ucsc-v1

      ----------------------------------------------------------------------------------------------------


