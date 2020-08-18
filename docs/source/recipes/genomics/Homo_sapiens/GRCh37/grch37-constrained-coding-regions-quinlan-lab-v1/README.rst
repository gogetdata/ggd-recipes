.. _`grch37-constrained-coding-regions-quinlan-lab-v1`:

grch37-constrained-coding-regions-quinlan-lab-v1
================================================

|downloads|

Constrained Coding Regions (CCRs): https://www.nature.com/articles/s41588-018-0294-6. Regions of human specific coding constraint presumably under strong purifying selection. Constraint is based on the lack of variation within the gnomAD dataset calibrated by the size and CpG content of the region. Regional Constraint is broken up into Autosomes and the X-Chromosome.

================================== ====================================
GGD Pacakge                        grch37-constrained-coding-regions-quinlan-lab-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      quinlan-lab
Data Version                       v2.2018-04-20
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz, grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi, grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz, grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi
Approximate Size of Each Data File grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz: **3.72M**, grch37-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi: **14.87K**, grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz: **154.44M**, grch37-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi: **412.79K**
Package Keywords                   constraint, coding-constraint, constrained-coding-regions, ccr
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-constrained-coding-regions-quinlan-lab-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-constrained-coding-regions-quinlan-lab-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-constrained-coding-regions-quinlan-lab-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-constrained-coding-regions-quinlan-lab-v1