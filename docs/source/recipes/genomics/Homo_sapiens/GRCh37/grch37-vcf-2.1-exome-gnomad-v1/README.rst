.. _`grch37-vcf-2.1-exome-gnomad-v1`:

grch37-vcf-2.1-exome-gnomad-v1
==============================

|downloads|

The gnomAD whole exome vcf file. Version 2.1.1 released on March 6, 2019. VCF file includes all non-neuro, non-cancer, controls-only, and non-TOPMed samples. (https://gnomad.broadinstitute.org/downloads)

================================== ====================================
GGD Pacakge                        grch37-vcf-2.1-exome-gnomad-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      NA
Data Version                       2.1.1
Genomic File Type                  NA
Data file coordinate basing        NA
Package's Data Files               NA
Approximate Size of Each Data File NA
Package Keywords                   gnomAD, genome-aggregation-database, Exome, vcf-file
Package Dependencies:              bcftools, htslib, openssl, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-vcf-2.1-exome-gnomad-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-vcf-2.1-exome-gnomad-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-vcf-2.1-exome-gnomad-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-vcf-2.1-exome-gnomad-v1