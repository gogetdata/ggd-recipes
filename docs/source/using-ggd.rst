.. _using-ggd:

Using GGD
=========

[:ref:`Click here to return to the home page <home-page>`]

**For a brief introduction to how ggd works and to start using ggd see:** :ref:`GGD Quick Start <quick-start>`

1. Install conda
----------------
ggd requires the conda package management system be installed on your system. Loading conda from a module
is not sufficient as data packages are stored in conda root. Please install Anaconda or Miniconda onto your system.
The best way to install is with the `Miniconda <http://conda.pydata.org/miniconda.html>`_
package. The Python 3 version is recommended.

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
ggd needs to be installed on your system before you can use it. Run the following commands to download the
ggd cli:

.. code-block:: bash

    $ conda install -y --file https://raw.githubusercontent.com/gogetdata/ggd-cli/master/requirements.txt
    $ pip install -U git+git://github.com/gogetdata/ggd-cli

4. ggd tools
------------
The ggd command line tool (cli) installed in step 3 has built-in tools for accessing and managing
data packages. These tools include:

- :ref:`ggd search <ggd-search>` Search for a ggd data package
- :ref:`ggd install <ggd-install>` Install a ggd data package
- :ref:`ggd uninstall <ggd-uninstall>` Uninstall a ggd data package
- :ref:`ggd list-files <ggd-list-files>` List the files for an installed ggd package
- :ref:`ggd pkg-info <ggd-pkg-info>` Show a specific ggd package's info
- :ref:`ggd show-env <ggd-show-env>` Show the ggd specific environment variables
- :ref:`ggd make-recipe <ggd-make-recipe>` Create a ggd recipe from a bash script
- :ref:`ggd check-recipe <ggd-check-recipe>` Check/test a ggd recipe

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

    $ ggd search -t reference genome

      grch37-reference-genome
       Summary: GRCh37 reference genome from 1000 genomes
       Species: Homo_sapiens
       Genome Build: GRCh37
       Keywords: ref, reference
       Data Version: phase2_reference

       To install run:
           ggd install grch37-reference-genome

      grch38-reference-genome
       Summary: GRCh37 reference genome from Ensembl
       Species: Homo_sapiens
       Genome Build: GRCh38
       Keywords: ref, reference
       Data Version: Release-95

       To install run:
           ggd install grch38-reference-genome

      . . .


2. Install the grch38 reference genome

.. code-block:: bash

    $ ggd install grch38-reference-genome

      -> Looking for grch38-reference-genome in the 'ggd-genomics' channel
      -> grch38-reference-genome exists in ggd-genomics
      -> grch38-reference-genome is not installed on your system
      -> grch38-reference-genome has not been installed by conda
      -> Installing grch38-reference-genome

      Solving environment:

       ## Package Plan ##

       environment location: <conda root>

         added / updated specs:
            - grch38-reference-genome

      The following packages will be downloaded:

         package                    |            build
         ---------------------------|-----------------
         grch38-reference-genome    |                0           6 KB  ggd-genomics

      The following NEW packages will be INSTALLED:

         grch38-reference-genome: 1-0 ggd-genomics


      Downloading and Extracting Packages
      grch38-reference-genome          | 6 KB      | ##############################
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      DONE


3. Identify the data environment variable or the file location

.. code-block:: bash

    $ ggd show-env
    ***************************
    Active environment variables:
    > $ggd_grch38_reference_genome
    ***************************

    $ ggd list-files grch38-reference-genome

    -> <conda root>/share/ggd/Homo_sapiens/GRCh38/grch38-reference-genome/1/grch38.fa
    -> <conda root>/share/ggd/Homo_sapiens/GRCh38/grch38-reference-genome/1/grch38.fa.fai


4. Use the files

