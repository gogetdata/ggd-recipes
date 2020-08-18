.. _`hg19-canonical-transcript-features-ensembl-v1`:

hg19-canonical-transcript-features-ensembl-v1
=============================================

|downloads|

Gene features from Ensembl Release-75 for protein-coding canonical transcripts based on the APPRIS transcript annotations. Features include gene, transcript, CDS, UTR, exon, start_codon, and stop_codon for all canonical transcripts. Canonical transcripts are determined based on APPRIS annotations. In short, for all protein coding transcripts, transcripts are filtered based on APPRIS isoform flags. If multiple transcripts of the same gene have equal flags, the isoform with the most exons is chosen. If all transcritps for a gene annotated by APPRIS are missing from the base gtf file no canonical transcript is chosen and the gene is removed. APPRIS flag information can be found here: http://appris-tools.org/#/downloads or here: https://uswest.ensembl.org/info/genome/genebuild/transcript_quality_tags.html. Remapped from Ensembl GRCh37 to UCSC hg19

================================== ====================================
GGD Pacakge                        hg19-canonical-transcript-features-ensembl-v1 
Species                            Homo_sapiens
Genome Build                       hg19
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      Ensembl
Data Version                       release-75_2-6-14
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               hg19-canonical-transcript-features-ensembl-v1.gtf.gz, hg19-canonical-transcript-features-ensembl-v1.gtf.gz.tbi
Approximate Size of Each Data File hg19-canonical-transcript-features-ensembl-v1.gtf.gz: **9.34M**, hg19-canonical-transcript-features-ensembl-v1.gtf.gz.tbi: **250.81K**
Package Keywords                   Canonical, Canonical-Transcripts, Canonical-Isoforms, Gene-Features, GTF, Ensembl-Gene-Set, Annotated-Transcripts
Package Dependencies:              hg19-chrom-mapping-ensembl2ucsc-ncbi-v1
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/hg19/hg19-canonical-transcript-features-ensembl-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics hg19-canonical-transcript-features-ensembl-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/hg19-canonical-transcript-features-ensembl-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/hg19-canonical-transcript-features-ensembl-v1