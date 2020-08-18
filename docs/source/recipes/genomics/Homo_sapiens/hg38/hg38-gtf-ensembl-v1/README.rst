.. _`hg38-gtf-ensembl-v1`:

hg38-gtf-ensembl-v1
===================

|downloads|

The GRCh38 gtf file from ensembl remapped to hg38 (Any unmapped entries are removed from the file)

================================== ====================================
GGD Pacakge                        hg38-gtf-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      NA
Data Version                       release-96
Genomic File Type                  NA
Data file coordinate basing        NA
Package's Data Files               NA
Approximate Size of Each Data File NA
Package Keywords                   gtf, gtf-file, ensembl
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-gtf-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-gtf-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-gtf-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-gtf-ensembl-v1