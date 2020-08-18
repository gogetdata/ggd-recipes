.. _`grch37-reference-genome-gencode-v1`:

grch37-reference-genome-gencode-v1
==================================

|downloads|

The GRCh37 DNA nucleotide sequence primary assembly. Sequence regions include reference chromsomes and scaffoldings.

================================== ====================================
GGD Pacakge                        grch37-reference-genome-gencode-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      GENCODE
Data Version                       release-34
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               grch37-reference-genome-gencode-v1.fa.gz, grch37-reference-genome-gencode-v1.fa.gz.fai, grch37-reference-genome-gencode-v1.fa.gz.gzi
Approximate Size of Each Data File grch37-reference-genome-gencode-v1.fa.gz: **881.99M**, grch37-reference-genome-gencode-v1.fa.gz.fai: **2.74K**, grch37-reference-genome-gencode-v1.fa.gz.gzi: **772.92K**
Package Keywords                   Reference-Genome, Fasta, DNA-Sequence, GENCODE-34, Fasta-sequence, primary-assemlby
Package Dependencies:              htslib, samtools, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-reference-genome-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-reference-genome-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-reference-genome-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-reference-genome-gencode-v1