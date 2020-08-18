.. _`grch37-missense-z-score-exac-v1`:

grch37-missense-z-score-exac-v1
===============================

|downloads|

Missense Z Score by gene. A constraint score based on missense variation, from Samocha et al., Nature Genetics 2014. The score is derived by calculating a null expectation of missense variation for each gene, and comparing it to what is observed in ExAC, then stratifying each gene using a Z score distribution. That paper is at: https://www.nature.com/articles/ng.3050

================================== ====================================
GGD Pacakge                        grch37-missense-z-score-exac-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      ExAC
Data Version                       Aug-31-2017
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-missense-z-score-exac-v1.bed.gz, grch37-missense-z-score-exac-v1.bed.gz.tbi
Approximate Size of Each Data File grch37-missense-z-score-exac-v1.bed.gz: **577.64K**, grch37-missense-z-score-exac-v1.bed.gz.tbi: **72.19K**
Package Keywords                   Constraint, Missense-Z, ExAC, Z-score, missense-variation, gene-constraint
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-missense-z-score-exac-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-missense-z-score-exac-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-missense-z-score-exac-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-missense-z-score-exac-v1