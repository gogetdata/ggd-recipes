.. _`grch38-reference-genome-gencode-v1`:

grch38-reference-genome-gencode-v1
==================================

|downloads|

Genome sequence, primary assembly. Nucleotide sequence of the GRCh38 primary genome assembly (chromosomes and scaffolds)

================================== ====================================
GGD Pacakge                        grch38-reference-genome-gencode-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      GENCODE
Data Version                       release-34
Genomic File Type                  fa
Data file coordinate basing        NA
Package's Data Files               grch38-reference-genome-gencode-v1.fa.gz, grch38-reference-genome-gencode-v1.fa.gz.fai, grch38-reference-genome-gencode-v1.fa.gz.gzi
Approximate Size of Each Data File grch38-reference-genome-gencode-v1.fa.gz: **894.51M**, grch38-reference-genome-gencode-v1.fa.gz.fai: **6.41K**, grch38-reference-genome-gencode-v1.fa.gz.gzi: **772.41K**
Package Keywords                   reference, primary-assembly, gencode, fasta
Package Dependencies:              htslib, samtools, samtools>=1.10, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-reference-genome-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-reference-genome-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-reference-genome-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-reference-genome-gencode-v1