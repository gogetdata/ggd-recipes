.. _ggd-search:

ggd search
==========

ggd search is used to search for a data package stored within the ggd system. It is dependent on the ggd channel
provided. 


Using ggd search 
----------------
Once ggd is installed on your system you can run :code:`ggd search` to search for available data packages.
Running :code:`ggd search -h` will give you the following help message: 

.. code-block:: bash 

    optional arguments:
        -h, --help            show this help message and exit
        -t TERM [TERM ...], --term TERM [TERM ...]
                            **Required** The term(s) to search for. Multiple terms can be used. Example: '-t reference genome'
        -g GENOME_BUILD, --genome_build GENOME_BUILD
                            (Optional) The genome build of the desired recipe
        -s {Canis_familiaris,Homo_sapiens,Drosophila_melanogaster,Mus_musculus}, --species {Canis_familiaris,Homo_sapiens,Drosophila_melanogaster,Mus_musculus}
                            (Optional) The species for the desired recipe
        -k KEYWORD [KEYWORD ...], --keyword KEYWORD [KEYWORD ...]
                            (Optional) Keyword(s) the are used to describe the recipe. Multiple keywords can be used. Example: '-k ref reference genome'
        -m MATCH_SCORE, --match_score MATCH_SCORE
                            (Optional) A score between 0 and 100 to use percent match between the search term(s) and the ggd-recipes
        -c {genomics}, --channel {genomics}
                            (Optional) The ggd channel to search. (Default = genomics)

Required Flags:

* -t: The :code:`-t` flag represents the "terms" to search for. At least one search term is required, but multiple can be provided 

Optional Flags:

* -g: The :code:`-g` flag is used to filter the search results on a specific "genome build". This flag is not required, however, if 
  provided the resulting search will be filtered to only include data packages with that genome build.
* -s: The :code:`-s` flag is used to filter the search results on a specific "species". Only data packages for that specific species 
  will be displayed.
* -k: The :code:`-k` flag is used to filter the search results based on keywords assigned to a pacakge. 
* -m: The :code:`-m` flag represents the "match" score to use for searcing. A fuzzy word match is used to identify similar packages
  to the terms search for, and the match score defines which packages will be displayed based on a cutoff. A default match score
  cutoff is provided, but this flag can be used to provide more strict or more lenient search results.
* -c: The :code:`-c` flag is used to set the ggd channel to search in. The ggd-genomics channel is set by default.

Any combination of search flags can be used to search for a package with the exception of the -t flag, which is required. 

Example
-------
Some examples of using the `ggd search` tool: 

1. Simple Example with one search term:
+++++++++++++++++++++++++++++++++++++++

.. code-block:: bash 

    $ ggd search -t reference 

      grch37-reference-genome
       Summary: GRCh37 reference genome from 1000 genomes
       Species: Homo_sapiens
       Genome Build: GRCh37
       Keywords: ref, reference
       Data Version: phase2_reference

       To install run:
           ggd install grch37-reference-genomet
    
      grch38-reference-genome
     .
     .
     .

2. Simple Example with two search term:
+++++++++++++++++++++++++++++++++++++++

.. code-block:: bash 

    $ ggd search -t repeat masker 

      hg38-repeatmasker
       Summary: RepeatMasker track from UCSC
       Species: Homo_sapiens
       Genome Build: hg38
       Keywords: rmsk, region
       Data Version: 06-Mar-2014
    
       To install run:
           ggd install hg38-repeatmasker
    
    
      hg19-repeatmasker
       Summary: RepeatMasker track from UCSC
       Species: Homo_sapiens
       Genome Build: hg19
       Keywords: rmsk, region
       Data Version: 27-Apr-2009
    
       To install run:
           ggd install hg19-repeatmasker
     .
     .
     .

3. Example using the -g, -s, and -k flags to filter the results:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash 

    $ ggd search -t reference genome -g grch37 -s Homo_sapiens -k ref   

      grch37-reference-genome
       Summary: GRCh37 reference genome from 1000 genomes
       Species: Homo_sapiens
       Genome Build: GRCh37
       Keywords: ref, reference
       Data Version: phase2_reference

       To install run:
           ggd install grch37-reference-genome



