.. _`hg38-ncbi-refseq-gene-features-ucsc-v1`:

hg38-ncbi-refseq-gene-features-ucsc-v1
======================================

|downloads|

Gene features for all curated and predicted annotations from the NCBI Refseq track from UCSC. (GTF). Refseq ALL. Human protein-coding and non-protein-coding genes from NCBI RNA reference seqeunce collection.

================================== ====================================
GGD Pacakge                        hg38-ncbi-refseq-gene-features-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       10-Jan-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz, hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz.tbi
Approximate Size of Each Data File hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz: **34.69M**, hg38-ncbi-refseq-gene-features-ucsc-v1.gtf.gz.tbi: **356.76K**
Package Keywords                   GTF, gene-feature-file, NCBI-Refseq, Refseq-All
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-ncbi-refseq-gene-features-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-ncbi-refseq-gene-features-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-ncbi-refseq-gene-features-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-ncbi-refseq-gene-features-ucsc-v1