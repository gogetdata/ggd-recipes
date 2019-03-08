.. _quick-start:

GGD Quick Start
===============

[:ref:`Click here to return to the home page <home-page>`]

Go Get Data (ggd) is a omics data managments system that provides access to processed and curated omic data files. 
ggd alleviates the difficulties and complexities of finding, obtaining, and processing the data sets and annotations
germane to your expriements and analyses. 

ggd provides a commmand line tool to search, install, uninstall, and other functions to work with omic data files.

To get more information about ggd and how to use it see :ref:`Using GGD <using-ggd>`.

To use ggd you will need to install it. 

1) Installing GGD
-----------------

This assumes you have installed and have access to the conda package managment system. If you have not, see :ref:`Using GGD <using-ggd>`.

Add the ggd-genomics channel to your systems conda configurations 

.. code-block:: bash

   $ conda config --add channels ggd-genomics

Install ggd with the following commands:

.. code-block:: bash

   $ conda install -y --file https://raw.githubusercontent.com/gogetdata/ggd-cli/master/requirements.txt
   $ pip install -U git+git://github.com/gogetdata/ggd-cli


2) Searching for data packages 
------------------------------

ggd provides an easy to use search tool to search and find the desired data packages.

.. code-block:: bash

   $ ggd search -t <data-package>


For example, if you need to install the GRCh38 reference genome from Ensembl you can use ggd to search and install the package

.. code-block:: bash

   $ ggd search -t reference 

or 

.. code-block:: bash

   $ ggd search -t genome 

or 

.. code-block:: bash

   $ ggd search -t reference genome 

3) Installing a data pacakge
----------------------------

ggd also provides an easy way to install data packages hosted in the ggd repo. Once you used the search function and found
a desired package, you can use the install command to install the data package.

.. code-block:: bash

    $ ggd install <data package>

For example, if you needed to install the GRCh38 reference genome from Ensembl, you have identify the data package using 
the ggd search tool, you can use the following command to install the package.

.. code-block:: bash

   $ ggd install grch38-reference-genome

If you look at the output from running `ggd install` you will see the system directory path to where the installed data packages
are stored, as well as an environmnet variable that can be used to access the data files.

4) Using the environment variables
----------------------------------

ggd will create an environment variable for each ggd data package that is intalled. To see all available environment variables 
use the following command:

.. code-block:: bash

    $ ggd show-env

If the environment variables are inactive, the output will tell you how to activate them. Once active, the environment variable 
can be used to access the data packages install by ggd. 

For example, if you installed the GRCh38 reference genome from Ensembl, you would get an environmnet variable like: 
:code:`ggd_grch38_reference_genome`. You can use this environment variable to acces your data.

To see the files for this ggd installed package you can use the following command: 

.. code-block:: bash

   $ ls $ggd_grch38_reference_genome

To move to the directory where the files are stored you can use the following command:

.. code-block:: bash

   $ cd $ggd_grch38_reference_genome

.. note::
    
    If you remove the files from this directory ggd will no longer be able to provide file handeling, version tracking, and 
    other functions. If you need to move these files please make a copy and move the copy.

5) Using the data pacakges
--------------------------

Now that you have downloaded the desired data packages you can use them for all of your experiements and analyses. ggd offers mutliple
functions in order to locate the data files installed by ggd, get the data package information, etc. For more information see 
:ref:`Using GGD <using-ggd>`. 


6) Additional Info
------------------

ggd is a powerful and easy to use tool to access and manage omic data. It helpes to overcome the difficulties with and time used
to find, obtain, and process the needed data for an experiments and/or analyses. ggd provides a stable source of versioning and 
reproducability. We intend ggd to become and commonly used data managment tool for researchers and scientists. 

To learn more about GGD see the :ref:`Home page <home-page>`, :ref:`Using GGD <using-ggd>`, or any other tab.



