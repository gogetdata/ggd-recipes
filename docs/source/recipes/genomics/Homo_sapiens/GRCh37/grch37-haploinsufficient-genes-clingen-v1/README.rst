.. _`grch37-haploinsufficient-genes-clingen-v1`:

grch37-haploinsufficient-genes-clingen-v1
=========================================

|downloads|

CDS region genomic coordinates, along with complement coordinates, for a set of haploinsufficient genes from ClinGen&#39;s Dosage Sensitivity Map curated by Daniel MacArthur&#39;&#39;s lab. The genes used are those that are haplosensitive and not triplosensitive, and are level 3 (the maximum level) dosage sensitive. Original work on this is part of the Cytogenomic Arrays Consortium. Paper at: &#39;https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5008023/&#39;. Any genes in patch regions or non-reference scaffoldings are not included.

================================== ====================================
GGD Pacakge                        grch37-haploinsufficient-genes-clingen-v1 
Species                            Homo_sapiens
Genome Build                       GRCh37
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      ClinGen
Data Version                       01-Sept-2016
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               grch37-haploinsufficient-genes-clingen-v1.bed.gz, grch37-haploinsufficient-genes-clingen-v1.bed.gz.tbi, grch37-haploinsufficient-genes-clingen-v1.compliment.bed.gz, grch37-haploinsufficient-genes-clingen-v1.compliment.bed.gz.tbi
Approximate Size of Each Data File grch37-haploinsufficient-genes-clingen-v1.bed.gz: **42.42K**, grch37-haploinsufficient-genes-clingen-v1.bed.gz.tbi: **14.19K**, grch37-haploinsufficient-genes-clingen-v1.compliment.bed.gz: **27.33K**, grch37-haploinsufficient-genes-clingen-v1.compliment.bed.gz.tbi: **13.98K**
Package Keywords                   haploinsufficiency, haploinsufficient, haploinsufficient-genes, genes, Clingen, gene-set
Package Dependencies:              bedtools, grch37-gene-features-ensembl-v1, gsort, htslib, pyexcel, pyexcel-xls, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh37/grch37-haploinsufficient-genes-clingen-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch37-haploinsufficient-genes-clingen-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch37-haploinsufficient-genes-clingen-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch37-haploinsufficient-genes-clingen-v1