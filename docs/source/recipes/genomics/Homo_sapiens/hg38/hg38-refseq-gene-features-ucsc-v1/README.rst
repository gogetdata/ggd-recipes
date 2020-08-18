.. _`hg38-refseq-gene-features-ucsc-v1`:

hg38-refseq-gene-features-ucsc-v1
=================================

|downloads|

The UCSC RefSeq gene track converted into GTF format containing known human protein-coding and non-protein-coding genes from RefSeq. (RefSeq: NCBI RNA reference sequence collection)

================================== ====================================
GGD Pacakge                        hg38-refseq-gene-features-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       01-Mar-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg38-refseq-gene-features-ucsc-v1.gtf.gz, hg38-refseq-gene-features-ucsc-v1.gtf.gz.tbi
Approximate Size of Each Data File hg38-refseq-gene-features-ucsc-v1.gtf.gz: **15.60M**, hg38-refseq-gene-features-ucsc-v1.gtf.gz.tbi: **315.64K**
Package Keywords                   RefSeq, GTF, protein-coding, non-protein-coding, refGene, UCSC-Refseq, Gene-Features
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-refseq-gene-features-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-refseq-gene-features-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-refseq-gene-features-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-refseq-gene-features-ucsc-v1