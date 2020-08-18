.. _`grch38-knowngene-gene-features-ucsc-v1`:

grch38-knowngene-gene-features-ucsc-v1
======================================

|downloads|

Gene features from the &#39;KnownGene&#39; track from UCSC. (GTF). Features include 5UTR, 3UTR, CDS, exon, start_codon, stop_codon, transcript. Features are comprised of all gene models from GENCODE v32. IDs correspond to the UCSC knowGene IDs. Remapped from UCSC hg38 to Ensembl GRCh38

================================== ====================================
GGD Pacakge                        grch38-knowngene-gene-features-ucsc-v1 
Species                            Homo_sapiens
Genome Build                       GRCh38
GGD Channel                        ggd-genomics
Package Version                    1
Recipe Author                      mjc 
Data Provider                      UCSC
Data Version                       10-Jan-2020
Genomic File Type                  gtf
Data file coordinate basing        1-based-inclusive
Package's Data Files               grch38-knowngene-gene-features-ucsc-v1.gtf.gz, grch38-knowngene-gene-features-ucsc-v1.gtf.gz.tbi
Approximate Size of Each Data File grch38-knowngene-gene-features-ucsc-v1.gtf.gz: **35.26M**, grch38-knowngene-gene-features-ucsc-v1.gtf.gz.tbi: **339.14K**
Package Keywords                   KnownGenes, gene-features, UCSC-Genes, feature-file, gene-feature-file, 5UTR, 3UTR, CDS, exon, start_codon, stop_codon, transcript, GTF, GENCODE-v32-genes
Package Dependencies:              grch38-chrom-mapping-ucsc2ensembl-ncbi-v1, gsort, htslib, zlib
Recipe                             https://github.com/gogetdata/ggd-recipes/tree/master/recipes/genomics/Homo_sapiens/GRCh38/grch38-knowngene-gene-features-ucsc-v1
================================== ====================================



Installation
------------

.. highlight: bash

With ggd insatlled and an activated ggd channel (see :ref:`using-ggd`), install with::

   ggd install -c ggd-genomics grch38-knowngene-gene-features-ucsc-v1

.. |downloads| image:: https://anaconda.org/ggd-genomics/grch38-knowngene-gene-features-ucsc-v1/badges/downloads.svg
               :target: https://anaconda.org/ggd-genomics/grch38-knowngene-gene-features-ucsc-v1