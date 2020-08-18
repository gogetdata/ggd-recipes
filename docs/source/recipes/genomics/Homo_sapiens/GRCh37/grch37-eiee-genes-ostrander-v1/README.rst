.. _`grch37-eiee-genes-ostrander-v1`:

grch37-eiee-genes-ostrander-v1
==============================

|downloads|

CDS region genomic coordinates, along with complement coordinates, for a set of eiee genes. The eiee gene set comes from a paper on EIEE (Early Infantile Epileptic Encephalopathy) a severe, fatal epileptic syndrome that occurs within the first few months of life. The gene set is a compilation of gene sets from a few different companies, gene panels, as well as one from the U of Chicago. Paper at: https://www.nature.com/articles/s41525-018-0061-8

================================== ====================================
GGD Pacakge                        grch37-eiee-genes-ostrander-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ostrander
Data Version                       13-Aug-2018
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-eiee-genes-ostrander-v1.bed.gz, grch37-eiee-genes-ostrander-v1.bed.gz.tbi, grch37-eiee-genes-ostrander-v1.complement.bed.gz, grch37-eiee-genes-ostrander-v1.complement.bed.gz.tbi
Approximate Size of Each Data File grch37-eiee-genes-ostrander-v1.bed.gz: **48.52K**, grch37-eiee-genes-ostrander-v1.bed.gz.tbi: **14.85K**, grch37-eiee-genes-ostrander-v1.complement.bed.gz: **30.66K**, grch37-eiee-genes-ostrander-v1.complement.bed.gz.tbi: **14.59K**
Package Keywords                   eiee, early-infantile, epileptic, epilepsy, encephalopathy, ostrander, genes, gene-set
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, htslib, pyexcel, pyexcel-xls, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-eiee-genes-ostrander-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-eiee-genes-ostrander-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-eiee-genes-ostrander-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-eiee-genes-ostrander-v1