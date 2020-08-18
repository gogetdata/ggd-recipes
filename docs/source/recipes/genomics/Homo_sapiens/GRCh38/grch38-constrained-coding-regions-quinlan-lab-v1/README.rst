.. _`grch38-constrained-coding-regions-quinlan-lab-v1`:

grch38-constrained-coding-regions-quinlan-lab-v1
================================================

|downloads|

*LiftOver* Constrained Coding Regions (CCRs): https://www.nature.com/articles/s41588-018-0294-6. Regions of human specific coding constraint presumably under strong purifying selection. Constraint is based on the lack of variation within the gnomAD dataset calibrated by the size and CpG content of the region. Regional Constraint is broken up into Autosomes and the X-Chromosome. Chromosome coordinates and CCR regions are lifted over from GRCh37 to GRCh38 using the Crossmap algorithm. Any unmapped regions are removed. Any region split into multiple regions are combined. (NOTE: The genomic coordinates have been remapped, but there has been no QC on the CCR percentiles preservation. It is yet to be determined if the CCR percentiles have been completely preserved during the liftover, but it can be assumed they should be similar based on the little to no change in region sizes.)

================================== ====================================
GGD Pacakge                        grch38-constrained-coding-regions-quinlan-lab-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      quinlan-lab
Data Version                       v2.2018-04-20
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz, grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi, grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz, grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi
Approximate Size of Each Data File grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz: **3.76M**, grch38-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi: **15.32K**, grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz: **155.68M**, grch38-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi: **413.13K**
Package Keywords                   constraint, coding-constraint, constrained-coding-regions, ccr
Package Dependencies:              crossmap, gsort, htslib, numpy, pandas, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-constrained-coding-regions-quinlan-lab-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-constrained-coding-regions-quinlan-lab-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-constrained-coding-regions-quinlan-lab-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-constrained-coding-regions-quinlan-lab-v1