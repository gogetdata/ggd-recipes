.. _`hg38-radar-li-lab-stanford-v1`:

hg38-radar-li-lab-stanford-v1
=============================

|downloads|

**Liftover** Rigorously Annotated Database of A-to-I RNA Editing (RADAR). A comprehensive collection of Adenosine (A) to Inosine (I) editing sites in human transcripts, otherwise known as RNA editing sites. Paper: http://nar.oxfordjournals.org/content/42/D1/D109. Liftover from hg19 to hg38

================================== ====================================
GGD Pacakge                        hg38-radar-li-lab-stanford-v1 
Species                            Homo_sapiens
Genome Build                       hg38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Li-Lab-Stanford
Data Version                       v2_02-Feb-2017
Genomic File Type                  bed
Data file coordinate basing        0-based-inclusive
Package's Data Files               hg38-radar-li-lab-stanford-v1.bed.gz, hg38-radar-li-lab-stanford-v1.bed.gz.tbi
Approximate Size of Each Data File hg38-radar-li-lab-stanford-v1.bed.gz: **15.28M**, hg38-radar-li-lab-stanford-v1.bed.gz.tbi: **795.72K**
Package Keywords                   RNA-Editing, A-to-I, Adenosine-to-Inosine, ADAR, Guanosine, RNA-Modification, post-transcriptional-modification, RADAR
Package Dependencies:              crossmap, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg38/hg38-radar-li-lab-stanford-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg38-radar-li-lab-stanford-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg38-radar-li-lab-stanford-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg38-radar-li-lab-stanford-v1