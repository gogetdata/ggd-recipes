.. _quick-start:

GGD Quick Start
===============

[:ref:`Click here to return to the home page <home-page>`]

.. warning::

    After December 31, 2020 GGD will no longer maintain python 2 compatibility. Python 2 may still work, but maintenance will
    be focused on python 3. This decision is based on the End-Of-Life of python 2 starting on January 1, 2020. GGD will maintain 
    python 2 compatibility for 1 year from the End-Of-Life of python 2.

**To see and/or search for data packages available through GGD, see:** :ref:`Available data packages <recipes>`

Go Get Data (ggd) is a genomics data management system that provides access to processed and curated genomic data files. 
ggd alleviates the difficulties and complexities of finding, obtaining, and processing the data sets and annotations
germane to your experiments and analyses. 

ggd provides a command line tool to search, install, and uninstall genomic data files and provides additional functions to work with the files installed onto your system. 

Below is a brief overview of some of the functionalities of ggd for a quick start guide to using the tool. To get more information about ggd and how to use it see :ref:`Using GGD <using-ggd>`.

To request a new data recipe please fill out the `GGD Recipe Request <https://forms.gle/3WEWgGGeh7ohAjcJA>`_ Form. 

To use ggd you will need to install it. 

1) Installing GGD
-----------------

This assumes you have installed and have access to the conda package management system. If you have not, see :ref:`Using GGD <using-ggd>`.

Add the required conda channels, including the ggd-genomics channel, to your systems conda configurations. (See commands below) 

.. code-block:: bash

    $ conda config --add channels defaults
    $ conda config --add channels ggd-genomics
    $ conda config --add channels bioconda
    $ conda config --add channels conda-forge

Install ggd with the following command:

.. code-block:: bash

   $ conda install -c bioconda ggd


2) Searching for data packages 
------------------------------

ggd provides an easy to use search tool to search and find the desired data packages.

.. code-block:: bash

   $ ggd search <1 or more search terms>


For example, if you need to install the human reference genome for genome build GRCh38 from Ensembl you can use ggd to search and install the package:

.. code-block:: bash

   $ ggd search reference 

or 

.. code-block:: bash

   $ ggd search genome 

or 

.. code-block:: bash

   $ ggd search reference genome 

or 

.. code-block:: bash

   $ ggd search grch38 reference genome

or 

.. code-block:: bash

   $ ggd search reference genome -s Homo_sapiens

or 

.. code-block:: bash

   $ ggd search reference genome -g GRCh38

etc. 


3) Installing a data package
----------------------------

ggd also provides an easy way to install data packages hosted in the ggd repo. Once you used the search function and found
the desired package(s), you can use the install command to install the data package(s).

.. code-block:: bash

    $ ggd install <1 or more data packages>

For example, if you needed to install the GRCh38 reference genome from Ensembl, which data package you had identified using 
the ggd search tool, you can use the following command to install the package:

.. code-block:: bash

   $ ggd install grch38-reference-genome-ensembl-v1

If you look at the output from running :code:`ggd install` you will see the system directory path to where the installed data packages
are stored, as well as an environment variable that can be used to access the data files.

.. note:: 
    
    You can install mutliple data packages with a single install command, or you can break the installation up into multiple commands. 
    For example, if you wanted to install pfam domains and cpg islands annotation file for the human genome build hg19 you could use the 
    following commands: 
    
    :code:`$ ggd install hg19-pfam-domains-ucsc-v1 hg19-cpg-islands-ucsc-v1`

    or

    :code:`$ ggd install hg19-pfam-domains-ucsc-v1`

    :code:`$ ggd install hg19-cpg-islands-ucsc-v1`
    

4) Listing installed packages
-----------------------------

You can get a list of every install data package installed using ggd for a specific conda environment using the :code:`ggd list` command. 

This command will provide information on which data packages are installed and the environment variables associated with those packages. 

For example, you could list all installed data files using the following command:

.. code-block:: bash

    $ ggd list

You could list all installed data packages installed in a different conda environment then the one you are currently in with the following command:

.. code-block:: bash

    $ ggd list --prefix <conda-environment-name>


    Example (list all data packages in the "my_data_environment" conda environment): 

        $ ggd list --prefix my_data_environmnet 

You can also list a subset of packages or even a specific package based on a pattern using the following command: 

.. code-block:: bash

    $ ggd list -p <pattern to match>
    
    Example (list all data packages that have the pattern "hg19"):

        $ ggd list -p hg19 


5) Using the environment variables
----------------------------------

ggd will create an environment variable for each ggd data package that is installed. To see all available environment variables 
use the following command:

.. code-block:: bash

    $ ggd show-env

These are the same environment variables that are seen when running :code:`ggd list`, however, this command is specific to information 
on avaiable environment variables that can be used for each data packages that has been installed on your system. 

If the environment variables are inactive, the output will tell you how to activate them. Once active, the environment variable 
can be used to access the data packages install by ggd. 

For most data packages two environment variables will be created. 
 * An environment variable that points to the directory path where the installed data is stored
 * An environment variable that points to the main installed file to use. 


For example, if you installed the GRCh38 reference genome from Ensembl, you would get two environment variable like: 
:code:`ggd_grch38_reference_genome_ensembl_v1_dir` and :code:`ggd_grch38_reference_genome_ensembl_v1_file`. 
You can use these environment variable to access your data.

To see the files for this ggd installed package you can use the following command: 

.. code-block:: bash

   $ ls $ggd_grch38_reference_genome_ensemble_v1_dir

To use the main file env var (Example showed is using an installed ref fasta to align reads):

.. code-block:: bash

     bwa mem $ggd_grch38_reference_genome_ensemble_v1_file reads.fq > aln.sam

To move to the directory where the files are stored you can use the following command:

.. code-block:: bash

   $ cd $ggd_grch38_reference_genome_ensemble_v1_dir

.. note::
    
    If you remove or change the files from this directory ggd will no longer be able to provide file and dependency handling, version tracking, and 
    other functions. If you need to move these files please make a copy and move the copy.


6) Fetching the data files with "get-files"
-------------------------------------------

GGD also provides a tool to fetch installed data files if you don't want to use or don't have access to the environment variables. (You will only have access to the 
environment variables if your are in the conda environment where the files were installed) 

If you are not in the conda environment where the data packages was installed, if you perfer not using the environment variables created for you, or if the environment variables available 
don't point to the file you would like to access, you can use :code:`ggd get-files` to fetch the desired files.

For example, if you wanted to get the GRCh38 reference genome fasta file you installed in step 3, you could use the following command:

.. code-block:: bash

    $ ggd get-files grch38-reference-genome-ensembl-v1 -p "*.fa"

    (Where -p is either the whole name of the data file you are interested in or a pattern to match the data file you are interseted in)

or if you wanted both the fasta file and the fasta indexed file you could run the following command:

.. code-block:: bash

    $ ggd get-files grch38-reference-genome-ensembl-v1


If your data package is stored in the :code:`my_data_environment` conda environment and you are in a different conda environment, you could access the data using this command:

.. code-block:: bash

    $ ggd get-files grch38-reference-genome-ensembl-v1 -p "*.fa" --prefix my_data_environment


7) Using the data packages
--------------------------

Now that you have downloaded the desired data packages you can use them for all of your experiments and analyses. ggd offers multiple
functions in order to locate the data files installed by ggd, get the data package information, etc. For more information see 
:ref:`Using GGD <using-ggd>`. 

For additional information and examples on using installed data packages see :ref:`Using installed data <using-installed-data>`. 


8) Additional Info
------------------

ggd is a powerful and easy to use tool to access and manage genomic data. It helps to overcome the difficulties with and time used
to find, obtain, and process the needed data for an experiments and/or analyses. ggd provides a stable source of versioning and 
reproducibility. We intend ggd to become and commonly used data management tool for researchers and scientists. 

To learn more about GGD see the :ref:`Home page <home-page>`, :ref:`Using GGD <using-ggd>`, or any other tab.

GGD was developed as an open source community contribution driven project. While the GGD team continues to maintain the tool and add new data packages, we encourage anyone that would like to contribute to the 
project to do so. For more information on how to contribute see :ref:`Contributing a data package to GGD <make-data-packages>`.



