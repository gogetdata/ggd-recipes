.. _`grch37-gene-features-ensembl-v1`:

grch37-gene-features-ensembl-v1
===============================

|downloads|

Gene features, including all annotated transcripts, that make up the Ensembl gene sets. (Alignment based annotation using proteins, cDNA, RNA-seq, etc.). Features are in GTF format.

================================== ====================================
GGD Pacakge                        grch37-gene-features-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-75_2-6-14
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch37-gene-features-ensembl-v1.gtf.gz, grch37-gene-features-ensembl-v1.gtf.gz.tbi
Approximate Size of Each Data File grch37-gene-features-ensembl-v1.gtf.gz: **40.32M**, grch37-gene-features-ensembl-v1.gtf.gz.tbi: **325.32K**
Package Keywords                   Gene-Features, GTF, Ensembl-GTF, Ensembl-Gene-Sets, Annotated-Transcripts
Package Dependencies:              gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-gene-features-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-gene-features-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-gene-features-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-gene-features-ensembl-v1