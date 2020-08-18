.. _`grch37-pli-scores-exac-v1`:

grch37-pli-scores-exac-v1
=========================

|downloads|

The probability of being loss-of-function intolerant (pLI) by gene scores from ExAC. See paper at: https://www.nature.com/articles/nature19057.

================================== ====================================
GGD Pacakge                        grch37-pli-scores-exac-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      ExAC
Data Version                       Aug-31-2017
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-pli-scores-exac-v1.bed.gz, grch37-pli-scores-exac-v1.bed.gz.tbi
Approximate Size of Each Data File grch37-pli-scores-exac-v1.bed.gz: **585.71K**, grch37-pli-scores-exac-v1.bed.gz.tbi: **72.39K**
Package Keywords                   pLI, Probability-of-being-loss-of-function-intolerant, Constraint, LoF-Intolerance, ExAC, gene-constraint
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-pli-scores-exac-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-pli-scores-exac-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-pli-scores-exac-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-pli-scores-exac-v1