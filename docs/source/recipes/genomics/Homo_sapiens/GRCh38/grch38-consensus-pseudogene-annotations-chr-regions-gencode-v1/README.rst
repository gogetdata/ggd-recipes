.. _`grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1`:

grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1
==============================================================

|downloads|

Consensus pseudogenes predicted by the Yale and UCSC pipelines. 2-way consensus (retrotransposed) pseudogenes predicted by the Yale and UCSC pipelines, but not by HAVANA, on the reference chromosomes. This dataset does not form part of the main annotation file.

================================== ====================================
GGD Pacakge                        grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      jrb 
Data Provider                      GENCODE
Data Version                       release-34
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1.gtf.gz, grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1.gtf.gz.tbi
Approximate Size of Each Data File grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1.gtf.gz: **361.23K**, grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1.gtf.gz.tbi: **103.59K**
Package Keywords                   gencode, pseudogene, pseudogenes, yale, UCSC, consensus, consensus-pseudogene, consensus-pseudogenes, annotation, gtf
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-consensus-pseudogene-annotations-chr-regions-gencode-v1