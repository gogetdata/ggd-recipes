.. _`hg19-self-chain-ucsc-v1`:

hg19-self-chain-ucsc-v1
=======================

|downloads|

Self chain alignemnts of the human genome with an improved gap scoring system. Alignemtns point out areas of duplication wihtin the human genome, with the exception of the pseudoautosomal regions on X and Y. From the Human Chained Self Alignemnts track on UCSC.

================================== ====================================
GGD Pacakge                        hg19-self-chain-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       27-Apr-2009
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-self-chain-ucsc-v1.bed.gz, hg19-self-chain-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File hg19-self-chain-ucsc-v1.bed.gz: **21.74M**, hg19-self-chain-ucsc-v1.bed.gz.tbi: **201.69K**
Package Keywords                   Self-Chain, Self-Alignment, Repeats, low-copy-repeats
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-self-chain-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-self-chain-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-self-chain-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-self-chain-ucsc-v1