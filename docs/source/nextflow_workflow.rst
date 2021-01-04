.. _nextflow_workflow:


Nextflow Workflow with GGD
==========================

[:ref:`Click here to return to the home page <home-page>`]

This simple example shows one approach of using GGD for a Nextflow workflow. 

In this example, we will use GGD to install a data package prior to running the nextflow workflow and using the data files 
during the nextflow workflow process. This is one of many approaches that can be taken to us GGD in a Nextflow workflow

For information on Nextflow workflows see `Nextflow Workflow docs <https://www.nextflow.io/docs/latest/index.html>`_.

**Description:**
In this example we are going to be using the `SeqCover <https://github.com/brentp/seqcover>`_ tool to interactively 
evaluate and QC the coverage of a few genes in a few 1000G samples. To do this, we are going to be using the 
nextflow workflow `seqcover-nf <https://github.com/brwnj/seqcover-nf>`_ created by Joe Brown. 

Nextflow Workflow Files
-----------------------

The files for this Nextflow workflow are provided below for convenience. However, the workflow is available `here <https://github.com/brwnj/seqcover-nf>`_.

**nextflow.config**

- This is the nextflow config file used to set the different configs for running the workflow. 

.. code-block:: yaml

    // Configurable variables
    params {
        outdir = './results'
        cpus = 4
        percentile = 5
    }

    process {
        time = 12.h
        memory = 8.GB
        cpus = 1
        cache = 'lenient'
    }

    profiles {
        docker {
            docker.enabled = true
        }
        singularity {
            singularity.runOptions = '--bind /scratch'
            singularity.enabled = true
        }
        none {}
    }

    process.shell = ['/bin/bash', '-euo', 'pipefail']

    timeline {
        enabled = true
        file = "${params.outdir}/logs/timeline.html"
    }
    report {
        enabled = true
        file = "${params.outdir}/logs/report.html"
    }
    trace {
        enabled = true
        file = "${params.outdir}/logs/trace.txt"
    }

    manifest {
        name = 'brwnj/seqcover-nf'
        author = 'Joe Brown'
        description = 'generate depth report per sample per gene'
        version = '0.1.0'
        nextflowVersion = '>=20.10.0'
        homePage = 'https://github.com/brwnj/seqcover-nf'
        mainScript = 'main.nf'
    }


**main.nf**

- This file is the main nextflow workflow file

- The workflow is as follows:

  - Run mosdepth to get per base coverage for each sample
  
  - Create a coverage background for the cohort using seqcover

  - Generate the seqcover report of the combined samples 


.. code-block:: python

    nextflow.enable.dsl=2

    params.help = false
    if (params.help) {
        log.info """
        -----------------------------------------------------------------------
        seqcover-nf
        ===========
        Documentation and issues can be found at:
        https://github.com/brwnj/seqcover-nf
        seqcover is available at:
        https://github.com/brentp/seqcover
        Required arguments:
        -------------------
        --crams               Aligned sequences in .bam and/or .cram format.
                              Indexes (.bai/.crai) must be present.
        --reference           Reference FASTA. Index (.fai) must exist in same
                              directory.
        --genes               Comma separated list of genes across which to
                              show coverage, e.g. "PIGA,KCNQ2,ARX,DNM1,SLC25A22,CDKL5".
        Options:
        --------
        --outdir              Base results directory for output.
                              Default: '/.results'
        --cpus                Number of cpus dedicated to `mosdepth` calls.
                              Default: 4
        --percentile          Background percentile used in seqcover report.
                              More info is available at:
                              https://github.com/brentp/seqcover#outlier
                              Default: 5
        -----------------------------------------------------------------------
        """.stripIndent()
        exit 0
    }

    params.crams = false
    params.reference = false
    params.outdir = './results'
    params.cpus = 4
    params.percentile = 5
    params.genes = false
    params.hg19 = false

    if(!params.crams) {
        exit 1, "--crams argument like '/path/to/*.cram' is required"
    }
    if(!params.reference) {
        exit 1, "--reference argument is required"
    }
    if(!params.genes) {
        exit 1, "--genes argument, e.g. 'PIGA,KCNQ2,ARX,DNM1', is required"
    }

    crams = channel.fromPath(params.crams)
    crais = crams.map { it -> it + ("${it}".endsWith('.cram') ? '.crai' : '.bai') }


    process mosdepth {
        container "brwnj/seqcover-nf:v0.1.0"
        publishDir "${params.outdir}/mosdepth"
        cpus params.cpus

        input:
        path(cram)
        path(crai)
        path(reference)

        output:
        path("*.d4"), emit: d4

        script:
        """
        mosdepth -f $reference -x -t ${task.cpus} --d4 ${cram.getSimpleName()} $cram
        """
    }

    process seqcover_background {
        container "brwnj/seqcover-nf:v0.1.0"
        publishDir params.outdir

        input:
        path(d4)
        path(reference)
        val(percentile)

        output:
        path("seqcover/*.d4"), emit: d4

        script:
        """
        seqcover generate-background -p 5 -f $reference -o seqcover/ $d4
        """
    }

    process seqcover_report {
        container "brwnj/seqcover-nf:v0.1.0"
        publishDir params.outdir

        input:
        path(d4)
        path(background)
        path(reference)
        val(genes)
        val(hg19)

        output:
        path("*.html"), emit: html

        script:
        genome_flag = hg19 ? "--hg19" : ""
        """
        seqcover report --fasta $reference --background $background --genes $genes $genome_flag $d4
        """
    }

    workflow {
        mosdepth(crams, crais, params.reference)
        seqcover_background(mosdepth.output.d4.collect(), params.reference, params.percentile)
        seqcover_report(mosdepth.output.d4.collect(), seqcover_background.output.d4, params.reference, params.genes, params.hg19)
    }




Steps to run the workflow 
--------------------------

1. Grab 1000G bam files. 

    5 bams and their indexes from 1000G to represent our alignments

    .. code-block:: bash

        mkdir data && cd data
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00096/alignment/HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20101123.bam
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00096/alignment/HG00096.chrom20.ILLUMINA.bwa.GBR.low_coverage.20101123.bam.bai
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00097/alignment/HG00097.chrom20.SOLID.bfast.GBR.low_coverage.20101123.bam
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00097/alignment/HG00097.chrom20.SOLID.bfast.GBR.low_coverage.20101123.bam.bai
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00182/alignment/HG00182.chrom20.ILLUMINA.bwa.FIN.low_coverage.20101123.bam
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00182/alignment/HG00182.chrom20.ILLUMINA.bwa.FIN.low_coverage.20101123.bam.bai
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00100/alignment/HG00100.chrom20.ILLUMINA.bwa.GBR.low_coverage.20101123.bam
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00100/alignment/HG00100.chrom20.ILLUMINA.bwa.GBR.low_coverage.20101123.bam.bai
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00183/alignment/HG00183.chrom20.ILLUMINA.bwa.FIN.low_coverage.20101123.bam
        wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/HG00183/alignment/HG00183.chrom20.ILLUMINA.bwa.FIN.low_coverage.20101123.bam.bai
        echo done

2. Use GGD to install a reference genome 

    We see from the header that 1000G uses GRCh37. Using ggd search we can find our reference:

    .. code-block:: bash

        ggd search -g GRCh37 reference genome

    Among the listings, we see the reference we need with install instructions:

    .. code-block:: bash

        ----------------------------------------------------------------------------------------------------

            grch37-reference-genome-1000g-v1
            ================================

            Summary: GRCh37 reference genome from 1000 genomes

            Species: Homo_sapiens

            Genome Build: GRCh37

            Keywords: ref, reference, fasta-file

            Data Version: phase2_reference

                .
                .
                .

            To install run:
                ggd install grch37-reference-genome-1000g-v1

          ----------------------------------------------------------------------------------------------------

    We install our reference:

    .. code-block:: bash

        ggd install grch37-reference-genome-1000g-v1

        # activate environmental variables
        source activate base


3. Run the Nextflow workflow 

    Now we have everything to QC our reads using a Nextflow workflow for seqcover.

    .. note::

        We are using the :code:`$ggd_grch37_reference_genome_1000g_v1_file` environment variable created by GGD when the 
        data package was installed. 

    .. code-block:: bash

        GENES="MYL9,TLDC2,NNAT,ADIG,FAM83D,PTPRT,SGK2,HNF4A"

        nextflow run brwnj/seqcover-nf -revision main -profile docker \
            --reference $ggd_grch37_reference_genome_1000g_v1_file \
            --crams 'data/*.bam' \
            --genes $GENES --hg19


    The Nextflow output gives:

    .. code-block:: bash

        N E X T F L O W  ~  version 20.10.0
        Launching `brwnj/seqcover-nf` [pedantic_jennings] - revision: 8bba84f42f [main]
        executor >  local (7)
        [bb/2fddf4] process > mosdepth (3)        [100%] 5 of 5 ✔
        [72/2ea7b3] process > seqcover_background [100%] 1 of 1 ✔
        [e5/8d2432] process > seqcover_report     [100%] 1 of 1 ✔
        Completed at: 25-Nov-2020 16:30:28
        Duration    : 12m 50s
        CPU hours   : 0.6
        Succeeded   : 7

And we have our results in ./results/seqcover_report.html.


Results:
--------

Here is the **seqcover_report.html** output from the above workflow

.. raw:: html

    <iframe src="_static/seqcover_report.html" height="1100px" width="100%"></iframe>








