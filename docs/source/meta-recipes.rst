.. _meta-recipes:

GGD meta-recipes
================

[:ref:`Click here to return to the home page <home-page>`]

**To see and/or search for data packages available through GGD, see:** :ref:`Available data packages <recipes>`

.. important::

    If you use GGD, please cite the `Nature Communications GGD paper <https://www.nature.com/articles/s41467-021-22381-z>`_

GGD supports the creation and use of non-specific recipes called `meta-recipe`. Meta-recipes are general recipes that can be used to access more specific recipes 
based on an Identifier. For example, the Gene Expression Omnibus (GEO) database is a large database of data from gene expression experiments: http://www.ncbi.nlm.nih.gov/geo. 
The GEO database contains millions of entries based on a GEO accession IDs. Storing each GEO accession ID as a single GGD recipe would be quite cumbersome and 
unrealistic to maintain. Therefore, rather then creating a single GGD recipe for every single GEO accession ID, a single GGD meta-recipe can be created which can be used
to access any GEO accession ID. 

GGD meta-recipes provide a powerful source of data access, reproducibility, and provenance. These meta-recipes contain the information on how to access, process, 
and install data based on the supplied ID. The installed pkg name will be specific to the ID supplied, making each ID specific meta-recipe unique. The specific 
commands used to install the data can be stored within the installed ID specific meta-recipe pkg metadata. Additionally, metadata for the installed ID specific 
meta-recipe pkg can be updated using information from the ID specific data. Therefore, in addition to being able to access data from a database like GEO with 
a single GGD meta-recipe, each ID specific meta-recipe installed will have updated metadata that is accessible specific to the ID and accessible through the 
:code:`pkg-info` command. 


GGD commands with meta-recipes
-------------------------------

Most GGD commands work with meta-recipes. These include: 

 - :code:`ggd install` to install an ID specific meta-recipe  
 - :code:`ggd list` to list installed ID specific meta-recipes
 - :code:`ggd show-env` to show the environment variables for ID specific meta-recipe(s)  
 - :code:`ggd pkg-info` to get the metadata/information of a ID specific meta-recipe 
 - :code:`ggd get-files` to get the installed data files for an ID specific meta-recipe 
 - :code:`ggd predict-path` to predict the directory path of an ID specific meta-recipe
 - :code:`ggd uninstall` to uninstall an ID specific meta-recipe(s) 
 - :code:`ggd make-meta-recipe` to make a meta-recipe from a single or group of scripts
 - :code:`ggd check-recipe` to test and check a new meta-recipe 
 - :code:`ggd search` to search for a meta-recipe (NOT an ID specific recipe)


Commands the don't work with meta-recipes include:

 - :code:`ggd make-recipe`: This command will only created a GGD recipe not a GGD meta-recipe. 


Conda Environments and Prefix
-----------------------------

One main advantage of GGD is the ability to install and access data files from GGD packages that are in different conda environments then the current 
active one. This is supported throughout GGD with the :code:`--prefix` parameter. 

The :code:`--prefix` parameter works for meta-recipes as well. This means you can install and access data files and metadata for ID specific meta-recipes
in a different environment then the currently active conda environment. 


Installation Time
-----------------

The process of installing a meta-recipe requires that the ID specific pkg be built locally. Therefore, installation time of a meta-recipe will be 
slightly longer then a GGD recipe that will install a similar number and size of data files. 

Installing a meta-recipe
------------------------

Installing a meta-recipe is just like installing a normal GGD recipe, except for the addition of the :code:`--id` parameter. The :code:`--id` parameter
is required in order to install a meta-recipe. If :code:`--id` is not provided then the recipe will not be installed. If the :code:`--id` parameter is 
provided but there is no meta-recipe being installed the id won't be used but a warning will be issued.

Example:
++++++++

.. code-block:: bash

    $ ggd install meta-recipe-geo-accession-geo-v1 --id GSE123

    :ggd:install: Looking for meta-recipe-geo-accession-geo-v1 in the 'ggd-genomics' channel

    :ggd:install: meta-recipe-geo-accession-geo-v1 exists in the ggd-genomics channel

    :ggd:install: meta-recipe-geo-accession-geo-v1 is a meta-recipe. Checking meta-recipe for installation

    :ggd:install: The ID specific recipe to be installed is 'gse123-geo-v1'.

    :ggd:install: gse123-geo-v1 version 1 is not installed on your system

    :ggd:repodata: Loading repodata from the Anaconda Cloud for the following channels: ggd-genomics

    :ggd:meta-recipe: Downloading meta-recipe package from conda to: '<conda root>/pkgs'

    :ggd:meta-recipe: Checking md5sum

    :ggd:meta-recipe: Successfully downloaded meta-recipe-geo-accession-geo-v1-1-0.tar.bz2 to <conda root>/pkgs

    :ggd:meta-recipe: Updating meta-recipe with ID info

    :ggd:install: Building new ID specific pkg

    :ggd:install: Successfully built new ID specific meta recipe

    :ggd:install: gse123-geo-v1 version 1 is not installed on your system

    :ggd:install: gse123-geo-v1 has not been installed by conda


    :ggd:install:   Attempting to install the following non-cached package(s):
        gse123-geo-v1

    ## Package Plan ##

      environment location: <conda root>

      added / updated specs:
        - gse123-geo-v1


    The following packages will be downloaded:

        package                    |            build
        ---------------------------|-----------------
        gse123-geo-v1-1            |                0           8 KB  local
        ------------------------------------------------------------
                                               Total:           8 KB

    The following NEW packages will be INSTALLED:

      gse123-geo-v1      ::gse123-geo-v1-1-0


    Downloading and Extracting Packages
    gse123-geo-v1-1      | 8 KB      | ####################################################################################################################################### | 100%
    Preparing transaction: done
    Verifying transaction: done
    Executing transaction: done

    :ggd:install: Loading Meta-Recipe ID specific environment variables

    :ggd:meta-recipe: Updating meta-recipe package metadata

    :ggd:install: Updating installed package list

    :ggd:install: Initiating data file content validation using checksum

    :ggd:install: Checksum for gse123-geo-v1

    :ggd:install: NOTICE: Skipping checksum for meta-recipe meta-recipe-geo-accession-geo-v1 => gse123-geo-v1

    :ggd:install: Install Complete


    :ggd:install: Installed file locations
    ======================================================================================================================

             GGD Package                                     Environment Variable(s)
         ----------------------------------------------------------------------------------------------------
    ->      gse123-geo-v1                                $ggd_gse123_geo_v1_dir


    Install Path: <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1


         ----------------------------------------------------------------------------------------------------

    :ggd:install: To activate environment variables run `source activate base` in the environment the packages were installed in

    :ggd:install: NOTE: These environment variables are specific to the <conda root> conda environment and can only be accessed from within that environment
    ======================================================================================================================


    :ggd:install: Environment Variables
    *****************************

    Active environment variables:
    > $ggd_gse123_geo_v1_dir

    To activate inactive or out-of-date vars, run:
    source activate base

    *****************************

    :ggd:install: DONE



Accessing installed ID specific meta-recipe 
-------------------------------------------

ID specific meta-recipe data files can be accessed just like any other GGD recipe. 

1) Get a list of installed data files:

.. code-block:: bash

    $ ggd list

    # Packages in environment: <conda env>
    #
    ------------------------------------------------------------------------------------------------------------------------
        Name                                Pkg-Version Pkg-Build   Channel         Environment-Variables
    ------------------------------------------------------------------------------------------------------------------------
    -> gse123-geo-v1                               1 [WARNING: Present in GGD but missing from Conda]                                  $ggd_gse123_geo_v1_dir

    # To use the environment variables run `source activate base`
    # You can see the available ggd data package environment variables by running `ggd show-env`

    #
    # NOTE: Packages with the '[WARNING: Present in GGD but missing from Conda]' messages represent packages where the ggd package(s) are installed, but the package metadata has been removed from conda storage. This happens when one of the following happen:
     1) The package represents an ID specific meta-recipe installed by GGD.
     2) When the recipe is built locally using 'ggd check-recipe' and has not been uninstalled. (Commonly for private data packages).
      Or
     3) The package is uninstalled using conda rather then ggd. The package is still available for use and is in the same state as before the 'conda uninstall'. To fix the problem on conda's side, uninstall the package with 'ggd uninstall' and re-install with 'ggd install'.


2) Show the env variable for installed pkgs:

.. code-block:: bash

    $ ggd show-env

    *****************************

    Active environment variables:
    > $ggd_gse123_geo_v1_dir

    Inactive or out-of-date environment variables:

    To activate inactive or out-of-date vars, run:
    source activate base

    *****************************


3) Get the files from an ID specific meta-recipe

.. code-block:: bash

    $ ggd get-files gse123-geo-v1
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3225_jzo016-rp1-v5-u74av2.CEL.gz
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSE123_series_matrix.txt.gz
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSE123_family.soft.gz
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3226_jzo022-rp1-v5-u74av2.CEL.gz
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3227_jzo026-rp1-v5-u74av2.CEL.gz

    $ ggd get-files gse123-geo-v1 --pattern "*.soft*"
    <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSE123_family.soft.gz


4) Get ID specific meta-recipe metadata info

.. code-block:: bash


    $ ggd pkg-info gse123-geo-v1 -sr

        ----------------------------------------------------------------------------------------------------

        GGD-Package: gse123-geo-v1

        GGD Parent Meta-Recipe: meta-recipe-geo-accession-geo-v1

        GGD-Channel: ggd-genomics

        GGD Pkg Version: 1

        Summary: GEO Accession ID: GSE123. Title: P7 knockout. GEO Accession site url: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=GSE123 (See the url for additional information about GSE123). Summary: Mice used were in a mixed background between 129/SvEv and C57BL/6. They were Rp1 knockout mice (Rp1-/-). Triplicates of RNA samples from Rp1-/- neural retinas for hybridization were collected at P7. Each RNA sample included a pool of neural retinas from 3-4 mice. Retinas were all collected at 1-2 pm of the day., Keywords: repeat sample Type: Expression profiling by array

        Species: (Updated) Mus musculus

        Genome Build: meta-recipe

        Keywords: Gene-Expression-Omnibus, GEO, GEO-Accession-ID, GEO-meta-recipe, GSE123, https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?targ=self&acc=GSE123, Expression profiling by array, , 

        Data Provider: GEO

        Data Version: Submission date: Dec 17 2002. Status: Public on Apr 15 2004. Last Update Date: Feb 18 2018. Download Date: 12-30-2020

        File type(s): 

        Data file coordinate base: NA

        Included Data Files: 
            GSM3225_jzo016-rp1-v5-u74av2.CEL.gz
            GSE123_series_matrix.txt.gz
            GSE123_family.soft.gz
            GSM3226_jzo022-rp1-v5-u74av2.CEL.gz
            GSM3227_jzo026-rp1-v5-u74av2.CEL.gz

        Approximate Data File Sizes: 
            GSE123_family.soft.gz: 3.62M
            GSE123_series_matrix.txt.gz: 130.06K
            GSM3225_jzo016-rp1-v5-u74av2.CEL.gz: 2.51M
            GSM3226_jzo022-rp1-v5-u74av2.CEL.gz: 2.58M
            GSM3227_jzo026-rp1-v5-u74av2.CEL.gz: 2.64M

        Pkg File Path: <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1

        Installed Pkg Files: 
            <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3225_jzo016-rp1-v5-u74av2.CEL.gz
            <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSE123_series_matrix.txt.gz
            <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSE123_family.soft.gz
            <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3226_jzo022-rp1-v5-u74av2.CEL.gz
            <conda root>/share/ggd/meta-recipe/meta-recipe/gse123-geo-v1/1/GSM3227_jzo026-rp1-v5-u74av2.CEL.gz

          ---------------------------------------------------------------------------------------------------- 



    gse123-geo-v1 recipe file:
    *****************************************************************************
    * 
    * curl "https://ftp.ncbi.nlm.nih.gov/geo/series/GSEnnn/GSE123/soft/GSE123_family.soft.gz" -O -J --silent
    * 
    * curl "https://ftp.ncbi.nlm.nih.gov/geo/series/GSEnnn/GSE123/matrix/GSE123_series_matrix.txt.gz" -O -J --silent
    * 
    * curl "https://ftp.ncbi.nlm.nih.gov/geo/series/GSEnnn/GSE123/suppl/GSE123_RAW.tar" -O -J --silent
    * 
    * tar -xf GSE123_RAW.tar
    *****************************************************************************
    :ggd:pkg-info: NOTE: The recipe provided above outlines where the data was accessed and how it was processed


5) PREFIX

As mentioned above, any GGD command that can use the :code:`--prefix` parameter can be used with meta-recipes. 

Therefore, one can install and access the data files of a ID specific meta-recipe in an environment that is different then the active one. Additionally, 
a meta-recipes metadata can be accessed in a different environment using :code:`ggd pkg-info` with the :code:`--prefix` parameter. 


Creating and Testing meta-recipes 
---------------------------------

Creating and testing a meta-recipe is similar to a normal recipe. However, meta-recipes required more detail within the data curation script(s). 

For more information about creating and testing a meta-recipe see :ref:`Creating a ggd meta-recipe <contribute-meta-recipe>`.



Meta-Recipe Caveats
-------------------

1) GGD currently only allows a single meta-recipe to be installed at a time. Therefore, if more than one meta-recipe needs to be installed each one would need 
   to be installed separately.


2) GGD does not cache meta-recipes. Therefore, if the database maintainer were to change/update ID specific data files, GGD would not be able to reproduce 
   data prior to the change. Additionally, meta-recipes do not get the installation speed up other general GGD recipes get. 


3) GGD does not check the contents of installed data files for ID specific meta-recipes using md5 checksums as it does with normal GGD recipes. This is because 
   database like GEO do not provide md5sum hash values for data hosted on their site. Therefore, GGD would have to precompute md5sum values for every single possible 
   file that could be downloaded. These md5sum hash values could potentially become stale very quickly with the possibility of database maintainers add/updating/changing 
   the hosted data. If a database provider does provide md5sums for data hosted on their site, the meta-recipe itself could implement a checksum, however, currently
   GGD does not plan to implement md5sum checking of data files for ID specific meta-recipes.



