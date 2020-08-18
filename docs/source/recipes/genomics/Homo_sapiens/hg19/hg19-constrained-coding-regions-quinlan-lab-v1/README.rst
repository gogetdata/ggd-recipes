.. _`hg19-constrained-coding-regions-quinlan-lab-v1`:

hg19-constrained-coding-regions-quinlan-lab-v1
==============================================

|downloads|

Constrained Coding Regions (CCRs): https://www.nature.com/articles/s41588-018-0294-6. Regions of human specific coding constraint presumably under strong purifying selection. Constraint is based on the lack of variation within the gnomAD dataset calibrated by the size and CpG content of the region. Regional Constraint is broken up into Autosomes and the X-Chromosome. Chromosomes have been remapped from Ensembl GRCh37 to UCSC hg19.

================================== ====================================
GGD Pacakge                        hg19-constrained-coding-regions-quinlan-lab-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      quinlan-lab
Data Version                       v2.2018-04-20
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg19-constrained-coding-regions-quinlan-lab-v1.X.bed.gz, hg19-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi, hg19-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz, hg19-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi
Approximate Size of Each Data File hg19-constrained-coding-regions-quinlan-lab-v1.X.bed.gz: **3.73M**, hg19-constrained-coding-regions-quinlan-lab-v1.X.bed.gz.csi: **14.88K**, hg19-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz: **155.06M**, hg19-constrained-coding-regions-quinlan-lab-v1.autosomes.bed.gz.csi: **413.52K**
Package Keywords                   constraint, coding-constraint, constrained-coding-regions, ccr
Package Dependencies:              gsort, hg19-chrom-mapping-ensembl2ucsc-ncbi-v1, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-constrained-coding-regions-quinlan-lab-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-constrained-coding-regions-quinlan-lab-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-constrained-coding-regions-quinlan-lab-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-constrained-coding-regions-quinlan-lab-v1