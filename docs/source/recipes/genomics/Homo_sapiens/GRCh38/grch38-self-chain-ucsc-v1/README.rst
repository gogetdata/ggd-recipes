.. _`grch38-self-chain-ucsc-v1`:

grch38-self-chain-ucsc-v1
=========================

|downloads|

Self chain alignemnts of the human genome with an improved gap scoring system. Alignemtns point out areas of duplication wihtin the human genome, with the exception of the pseudoautosomal regions on X and Y. From the Human Chained Self Alignemnts track on UCSC. Remapped from UCSC hg38 to Ensembl GRCh37

================================== ====================================
GGD Pacakge                        grch38-self-chain-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       06-Mar-2014
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-self-chain-ucsc-v1.bed.gz, grch38-self-chain-ucsc-v1.bed.gz.tbi
Approximate Size of Each Data File grch38-self-chain-ucsc-v1.bed.gz: **790.34M**, grch38-self-chain-ucsc-v1.bed.gz.tbi: **700.77K**
Package Keywords                   Self-Chain, Self-Alignment, Repeats, low-copy-repeats
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-self-chain-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-self-chain-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-self-chain-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-self-chain-ucsc-v1