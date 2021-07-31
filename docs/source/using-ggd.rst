.. _using-ggd:

Using GGD
=========

[:ref:`Click here to return to the home page <home-page>`]

**To see and/or search for data packages available through GGD, see:** :ref:`Available data packages <recipes>`

**For a brief introduction to how ggd works and to start using ggd see:** :ref:`GGD Quick Start <quick-start>`

**To request a new data recipe please fill out the** `GGD Recipe Request <https://forms.gle/3WEWgGGeh7ohAjcJA>`_ **Form.** 

.. important::

    If you use GGD, please cite the `Nature Communications GGD paper <https://www.nature.com/articles/s41467-021-22381-z>`_

1. Install conda
----------------
ggd requires the conda package management system be installed on your system. Loading conda from a module
is not sufficient as data packages are stored in conda root. Please install Anaconda or Miniconda onto your system.
The best way to install is with the `Miniconda <http://conda.pydata.org/miniconda.html>`_
package. We specifically recommend using the Python 3 version.

.. warning::

    After December 31, 2020 GGD will no longer maintain python 2 compatibility. Python 2 may still work, but maintenance will
    be focused on python 3. This decision is based on the End-Of-Life of python 2 starting on January 1, 2020. GGD will maintain 
    python 2 compatibility for 1 year from the End-Of-Life of python 2.


2. Configure the conda channels
--------------------------------
ggd data packages are stored in the Anaconda cloud. Additionally, ggd uses software tools available from
other software packages in conda. A ggd conda channel, and other required channels, need to be added to your conda
configurations. You can add as many available ggd channels as you would like, but only one of the available
ggd channels is required. As ggd becomes more widely used, additional channels will be created to support different areas of
research.

Available ggd channels:

- ggd-genomics

Run the following commands, adding in additional ggd channels as desired:

.. code-block:: bash

    $ conda config --add channels defaults
    $ conda config --add channels ggd-genomics
    $ conda config --add channels bioconda
    $ conda config --add channels conda-forge

3. Install ggd
--------------

.. note::

    Step 2 above is required prior to installing ggd. If Step 2 has not been completed ggd installation will fail


ggd needs to be installed on your system before you can use it. Run the following commands to download the
ggd cli:

.. code-block:: bash

    $ conda install -c bioconda ggd

4. ggd tools
------------
The ggd command line tool (cli) installed in step 3 has built-in tools for accessing and managing
data packages. These tools include:

- :code:`$ ggd search`: Search for a ggd data package
- :code:`$ ggd predict-path`: Predict the file path of a data package that has not been installed yet (Good for workflows like Snakemake)
- :code:`$ ggd install`: Install ggd data package(s)
- :code:`$ ggd uninstall`: Uninstall a ggd data package(s)
- :code:`$ ggd list`: List the installed data packages
- :code:`$ ggd get-files`: get the files for an installed ggd package
- :code:`$ ggd pkg-info`: Show a specific ggd package's info
- :code:`$ ggd show-env`: Show the ggd specific environment variables
- :code:`$ ggd make-recipe`: Create a ggd recipe from a bash script
- :code:`$ ggd make-meta-recipe`: Create a ggd meta-recipe 
- :code:`$ ggd check-recipe`: Check/test a ggd recipe

For information about specific tools see: :ref:`GGD-CLI <ggd_cli_page>`

5. Contributing to ggd
----------------------
We intend for ggd to become a widely used data management system for genomics and other research areas.
ggd provides support for reproducibility through conda's naming, version tracking, and dependency handling structure.
One major function of the ggd cli tools is to provide an easy way to add data packages to the data repository.

We welcome and encourage everyone to contribute to the data repository hosted by ggd.

Instructions on how to create a data package and add it to ggd can be found on the :ref:`Contribute <make-data-packages>`
documentation pages.


ggd Use Case
------------

You need to align some sequence(s) to the human reference genome for a given analysis.
You will need to find and download the correct reference genome from one of the sites that hosts it and make sure it is
the correct genome build. You will then need to sort and index the reference genome before you can use it.

ggd simplifies this process by allowing you to search
and install available processed genomic data packages using the ggd tool.

1. Search for a reference genome

.. code-block:: bash

    $ ggd search reference genome

    ----------------------------------------------------------------------------------------------------

      grch37-reference-genome-ensembl-v1
      ==================================

	  Summary: The GRCh37 unmasked genomic DNA seqeunce reference genome from Ensembl-Release 75. Includes all sequence regions EXCLUDING haplotypes and patches. 'Primary Assembly file'

      Species: Homo_sapiens

      Genome Build: GRCh37

      Keywords: Primary-Assembly, Release-75, ref, reference, Ensembl-ref, DNA-Seqeunce, Fasta-Seqeunce, fasta-file

      Data Provider: Ensembl

      Data Version: release-75_2-3-14

      File type(s): fa

      Data file coordinate base: NA

      Included Data Files:
          grch37-reference-genome-ensembl-v1.fa
          grch37-reference-genome-ensembl-v1.fa.fai

      Approximate Data File Sizes:
          grch37-reference-genome-ensembl-v1.fa: 3.15G
          grch37-reference-genome-ensembl-v1.fa.fai: 2.74K


      To install run:
          ggd install grch37-reference-genome-ensembl-v1

    ----------------------------------------------------------------------------------------------------

        grch38-reference-genome-ensembl-v1
        ==================================

        Summary: The GRCh38 unmasked genomic DNA sequence reference genome from Ensembl-Release 99. Includes all sequence regions EXCLUDING haplotypes and patches. 'Primary Assembly file'

        Species: Homo_sapiens

        Genome Build: GRCh38

        Keywords: Primary-Assembly, Release-99, ref, reference, Ensembl-ref, DNA-Sequence, Fasta-Sequence, fasta-file

        Data Provider: Ensembl

        Data Version: release-99_11-18-19

        File type(s): fa

        Data file coordinate base: NA

        Included Data Files:
            grch38-reference-genome-ensembl-v1.fa
            grch38-reference-genome-ensembl-v1.fa.fai

        Approximate Data File Sizes:
            grch38-reference-genome-ensembl-v1.fa: 3.15G
            grch38-reference-genome-ensembl-v1.fa.fai: 6.41K


      To install run:
          ggd install grch38-reference-genome-ensembl-v1

    ----------------------------------------------------------------------------------------------------

      . . .


2. Install the grch38 reference genome

.. code-block:: bash

    $ ggd install grch38-reference-genome-ensembl-v1

        :ggd:install: Looking for grch38-reference-genome-ensembl-v1 in the 'ggd-genomics' channel

        :ggd:install: grch38-reference-genome-ensembl-v1 exists in the ggd-genomics channel

        :ggd:install: grch38-reference-genome-ensembl-v1 version 1 is not installed on your system

        :ggd:install: grch38-reference-genome-ensembl-v1 has not been installed by conda

        :ggd:install: The grch38-reference-genome-ensembl-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket


        :ggd:install:   Attempting to install the following cached package(s):
            grch38-reference-genome-ensembl-v1


        :ggd:utils:bypass: Installing grch38-reference-genome-ensembl-v1 from the ggd-genomics conda channel

        Collecting package metadata: done
        Processing data: done

        ## Package Plan ##

          environment location: <conda-root>

          added / updated specs:
            - grch38-reference-genome-ensembl-v1


        The following packages will be downloaded:

            package                    |            build
            ---------------------------|-----------------
            grch38-reference-genome-ensembl-v1-1|                3           7 KB  ggd-genomics
            ------------------------------------------------------------
                                                   Total:           7 KB

        The following NEW packages will be INSTALLED:

          grch38-reference-~ ggd-genomics/noarch::grch38-reference-genome-ensembl-v1-1-0



        Downloading and Extracting Packages
        grch38-reference-gen | 7 KB      | ############################################################################################################################################## | 100% 
        Preparing transaction: done
        Verifying transaction: done
        Executing transaction: done

        :ggd:install: Updating installed package list

        :ggd:install: Initiating data file content validation using checksum

        :ggd:install: Checksum for grch38-reference-genome-ensembl-v1
        :ggd:checksum: installed  file checksum: grch38-reference-genome-ensembl-v1.fa.fai checksum: d527f3eb6b664020cf4d882b5820056f
        :ggd:checksum: metadata checksum record: grch38-reference-genome-ensembl-v1.fa.fai checksum: d527f3eb6b664020cf4d882b5820056f 

        :ggd:checksum: installed  file checksum: grch38-reference-genome-ensembl-v1.fa checksum: 9e6b9465dc708d92bf6d67e9c9fa9389
        :ggd:checksum: metadata checksum record: grch38-reference-genome-ensembl-v1.fa checksum: 9e6b9465dc708d92bf6d67e9c9fa9389 

        :ggd:install: ** Successful Checksum **

        :ggd:install: Install Complete


        :ggd:install: Installed file locations
        ======================================================================================================================

                 GGD Package                                     Environment Variable(s)                                    
             ----------------------------------------------------------------------------------------------------
            -> grch38-reference-genome-ensembl-v1                      $ggd_grch38_reference_genome_ensembl_v1_dir                     
                                                                      $ggd_grch38_reference_genome_ensembl_v1_file                     


            Install Path: <conda-root>/share/ggd/Homo_sapiens/GRCh38/grch38-reference-genome-ensembl-v1/1


             ---------------------------------------------------------------------------------------------------- 

        :ggd:install: To activate environment variables run `source activate base` in the environmnet the packages were installed in

        :ggd:install: NOTE: These environment variables are specific to the <conda-root> conda environment and can only be accessed from within that environmnet
        ======================================================================================================================




        :ggd:install: Environment Variables
        *****************************

        Inactive or out-of-date environment variables:
        > $ggd_grch38_reference_genome_ensembl_v1_dir
        > $ggd_grch38_reference_genome_ensembl_v1_file

        To activate inactive or out-of-date vars, run:
        source activate base

        *****************************

3. Identify the data environment variable or the file location

.. code-block:: bash

    $ ggd show-env
    ***************************
    Active environment variables:
    > $ggd_grch38_reference_genome_ensembl_v1_dir
    > $ggd_grch38_reference_genome_ensembl_v1_file
    ***************************

    $ ggd get-files grch38-reference-genome-ensembl-v1
    <conda root>/share/ggd/Homo_sapiens/GRCh38/grch38-reference-genome-ensembl-v1/1/grch38.fa
    <conda root>/share/ggd/Homo_sapiens/GRCh38/grch38-reference-genome-ensembl-v1/1/grch38.fa.fai


4. Use the files

For additional information and examples on how to use the installed data files see: :ref:`Using installed data <using-installed-data>`. 

