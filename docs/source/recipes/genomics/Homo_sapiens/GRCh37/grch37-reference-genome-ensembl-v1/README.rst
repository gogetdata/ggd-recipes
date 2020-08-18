.. _`grch37-reference-genome-ensembl-v1`:

grch37-reference-genome-ensembl-v1
==================================

|downloads|

The GRCh37 unmasked genomic DNA seqeunce reference genome from Ensembl-Release 75. Includes all sequence regions EXCLUDING haplotypes and patches. &#39;Primary Assembly file&#39;

================================== ====================================
GGD Pacakge                        grch37-reference-genome-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-75_2-3-14
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               grch37-reference-genome-ensembl-v1.fa, grch37-reference-genome-ensembl-v1.fa.fai
Approximate Size of Each Data File grch37-reference-genome-ensembl-v1.fa: **3.15G**, grch37-reference-genome-ensembl-v1.fa.fai: **2.74K**
Package Keywords                   Primary-Assembly, Release-75, ref, reference, Ensembl-ref, DNA-Seqeunce, Fasta-Seqeunce, fasta-file
Package Dependencies:              samtools, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-reference-genome-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-reference-genome-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-reference-genome-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-reference-genome-ensembl-v1