.. _ggd-install:

ggd install
===========

[:ref:`Click here to return to the home page <home-page>`]

ggd install is used to install a ggd package from the Anaconda cloud. ggd install determines your file system and ensures
a proper install. If the package fails to install for some reason it will clean up the failed install.

ggd provide functionality to install multiple packages at the same time by appending data package names as positional arguments 
during the install command, and/or using the :code:`--file` flag. 

ggd also provides functionality to install and use data packages into a different conda environment then the one you are currently
in using the :code:`--prefix` flag. 

Examples are available at the bottom of this page that highlight the functionality of :code:`ggd install`

    .. note::

        Running :code:`conda install <package>` will NOT work!! There are specific steps that GGD takes in order to install a 
        data package that conda does not. **Please use** :code:`ggd install <package>` **when installing a ggd data package**.


Using ggd install
-----------------
Use :code:`ggd install` to install a data package hosted by ggd.
Running :code:`ggd install -h` will give you the following message:


Install arguments:

+--------------------+---------------------------------------------------------------------------------------------------+
| ggd install        | Install a ggd data package into the current or specified conda environment                        |
+====================+===================================================================================================+
| -h, --help         | show this help message and exit                                                                   |
+--------------------+---------------------------------------------------------------------------------------------------+
| name               | **Required** The data package name to install. Can use more than                                  |
|                    | once (e.g. ggd install <pkg 1> <pkg 2> <pkg 3> )                                                  |
|                    | (NOTE: No need to designate version as it is                                                      |
|                    | implicated in the package name)                                                                   |
+--------------------+---------------------------------------------------------------------------------------------------+
| -c, --channel      | (Optional) The ggd channel the desired recipe is stored in.(Default = genomics)                   |
+--------------------+---------------------------------------------------------------------------------------------------+
| -d, --debug        | (Optional) When the -d flag is set debug output will be printed to stdout.                        |
+--------------------+---------------------------------------------------------------------------------------------------+
| --file FILE        | A file with a list of ggd data packages to install.                                               |
|                    | One package per line. Can use more than one (e.g. ggd                                             |
|                    | install --file <file_1> --file <file_2> )                                                         |
+--------------------+---------------------------------------------------------------------------------------------------+
| --prefix           | (Optional) The name or the full directory path to an                                              |
|                    | existing conda environment where you want to install a                                            |
|                    | ggd data package. (Only needed if you want to install                                             |
|                    | the data package into a different conda environment                                               |
|                    | then the one you are currently in)                                                                |
+--------------------+---------------------------------------------------------------------------------------------------+


Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *name:* The :code:`name` represents the name(s) of the ggd package(s) to download and is required. If the name
  provided is not in the ggd channel it will not be downloaded, and the user will be informed. At least one package
  name is required, but multiple names can be supplied 

Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel. The default channel is *genomics*. If the data package
  you want to install is in a different ggd channel you will need to supply the channel name using this flag.

  For example, if the data was located in the 'proteomics' channel, you would use::

     ggd install <package> -c proteomics

* *--file:* The :code:`--file` flag is used to install data packages listed in a file. It requires that the each package 
  in the file be separated by a new line, that is, one package name per line. This is similar to a requirements.txt file
  used for installing software packages from conda. (See  :ref:`example 4 below <ggd-install-example-4>`.

* *--prefix:* The :code:`--prefix` flag is used to install a data package into a different conda environment/prefix then 
  the current one you are in. This flag is commonly used when a environment has been created to store data packages without 
  having duplicate copies of a packge in different environments. You can store all data packages in a single environment and
  access them from any other environment using the :code:`--prefix` flag available in other ggd tools



    .. note::
    
        During the installation you will see a multiple progress spinners. The time it takes to install the data package(s) 
        is dependent on how big the data package is being installed as well as the internet bandwith you have. When you see: 
        **Executing Transaction |-** you are in the final stages of installation, however, this stage takes the longest. 
        Please be patient as the package is being installed, processed, and curated. 


    .. note::
    
        Environment variable(s) are created for each data package installed for easy access and use. Most of the time these
        environment variables need to be activated. After the installation is complete, run the following command to activate:
        :code:`source activate base`

Examples
--------

1. Failed install example:
++++++++++++++++++++++++++

::

    $ ggd install hg19-ga

      :ggd:install: Looking for hg19-ga in the 'ggd-genomics' channel

      :ggd:install: 'hg19-ga' was not found in ggd-genomics
      :ggd:install:  You can search for recipes using the ggd search tool: 
          'ggd search hg19-ga'

2. Successful install example:
++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd install hg19-gaps-ucsc-v1


      :ggd:install: Looking for hg19-gaps-ucsc-v1 in the 'ggd-genomics' channel

      :ggd:install: hg19-gaps-ucsc-v1 exists in the ggd-genomics channel

      :ggd:install: hg19-gaps-ucsc-v1 version 1 is not installed on your system

      :ggd:install: hg19-gaps-ucsc-v1 has not been installed by conda

      :ggd:install: The hg19-gaps-ucsc-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket


      :ggd:install:   Attempting to install the following cached package(s):
        hg19-gaps-ucsc-v1


      :ggd:utils:bypass: Installing hg19-gaps-ucsc-v1 from the ggd-genomics conda channel

      Collecting package metadata: done
      Processing data: done

      ## Package Plan ##

        environment location: <env>

        added / updated specs:
          - hg19-gaps-ucsc-v1


      The following packages will be downloaded:

          package                    |            build
          ---------------------------|-----------------
          hg19-gaps-ucsc-v1-1        |                1           6 KB  ggd-genomics
          ------------------------------------------------------------
                                                 Total:           6 KB

      The following NEW packages will be INSTALLED:

        hg19-gaps-ucsc-v1  ggd-genomics/noarch::hg19-gaps-ucsc-v1-1-1



      Downloading and Extracting Packages
      hg19-gaps-ucsc-v1-1  | 6 KB      | ############################################################################ | 100% 
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      :ggd:install: Updating installed package list

      :ggd:install: Initiating data file content validation using checksum

      :ggd:install: Checksum for hg19-gaps-ucsc-v1

      :ggd:install: ** Successful Checksum **

      :ggd:install: Install Complete


      :ggd:install: Installed file locations
      ======================================================================================================================

               GGD Package                                     Environment Variable(s)                                    
           ----------------------------------------------------------------------------------------------------
      ->  hg19-gaps-ucsc-v1                              $ggd_hg19_gaps_ucsc_v1_dir                              
                                                         $ggd_hg19_gaps_ucsc_v1_file                             


      Install Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1


           ---------------------------------------------------------------------------------------------------- 

      :ggd:install: To activate environment variables run `source activate base` in the environment the packages were installed in

      :ggd:install: NOTE: These environment variables are specific to the <env> conda environment and can only be accessed from within that environment
      ======================================================================================================================




      :ggd:install: Environment Variables
      *****************************

      Inactive or out-of-date environment variables:
      > $ggd_hg19_gaps_ucsc_v1_dir
      > $ggd_hg19_gaps_ucsc_v1_file

      To activate inactive or out-of-date vars, run:
      source activate base

      *****************************


      :ggd:install: DONE



.. note::

    To activate environment variables run:
    :code:`source activate base`



3. Successful install with multiple packages:
+++++++++++++++++++++++++++++++++++++++++++++

You can install multiple data packages at the same time. You simply append the name of each data package after the :code:`ggd install` 
command. The example below shows the install for two data packages, but there is no limit to the number of data packages to install at 
the same time. 

.. note::
  
    The more data packages you append to the install command the longer it will take to install them. 


.. note::
  
    If one of the data packages doesn't install correctly, doesn't exists as a data package in ggd, or has some problem during installation, 
    the installation process will not finish and the process will be rolled back. That is, NO data packages will be installed


.. code-block:: bash

    $ ggd install grch37-haploinsufficient-genes-clingen-v1 grch37-microsatellites-ucsc-v1


      :ggd:install: Looking for grch37-haploinsufficient-genes-clingen-v1 in the 'ggd-genomics' channel

      :ggd:install: grch37-haploinsufficient-genes-clingen-v1 exists in the ggd-genomics channel

      :ggd:install: grch37-haploinsufficient-genes-clingen-v1 version 1 is not installed on your system

      :ggd:install: grch37-haploinsufficient-genes-clingen-v1 has not been installed by conda


      :ggd:install: Looking for grch37-microsatellites-ucsc-v1 in the 'ggd-genomics' channel

      :ggd:install: grch37-microsatellites-ucsc-v1 exists in the ggd-genomics channel

      :ggd:install: grch37-microsatellites-ucsc-v1 version 1 is not installed on your system

      :ggd:install: grch37-microsatellites-ucsc-v1 has not been installed by conda

      :ggd:install: The grch37-haploinsufficient-genes-clingen-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket

      :ggd:install: The grch37-microsatellites-ucsc-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket


      :ggd:install:   Attempting to install the following cached package(s):
        grch37-haploinsufficient-genes-clingen-v1
        grch37-microsatellites-ucsc-v1


      :ggd:utils:bypass: Installing grch37-haploinsufficient-genes-clingen-v1, grch37-microsatellites-ucsc-v1 from the ggd-genomics conda channel

      Collecting package metadata: done
      Processing data: done

      ## Package Plan ##

        environment location: <envs>

        added / updated specs:
          - grch37-haploinsufficient-genes-clingen-v1
          - grch37-microsatellites-ucsc-v1


      The following packages will be downloaded:

          package                    |            build
          ---------------------------|-----------------
          grch37-haploinsufficient-genes-clingen-v1-1|                1           8 KB  ggd-genomics
          grch37-microsatellites-ucsc-v1-1|                1           7 KB  ggd-genomics
          ------------------------------------------------------------
                                                 Total:          15 KB

      The following NEW packages will be INSTALLED:

        grch37-haploinsuf~ ggd-genomics/noarch::grch37-haploinsufficient-genes-clingen-v1-1-1
        grch37-microsatel~ ggd-genomics/noarch::grch37-microsatellites-ucsc-v1-1-1



      Downloading and Extracting Packages
      grch37-microsatellit | 7 KB      | ############################################################################ | 100% 
      grch37-haploinsuffic | 8 KB      | ############################################################################ | 100% 
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      :ggd:install: Updating installed package list

      :ggd:install: Initiating data file content validation using checksum

      :ggd:install: Checksum for grch37-haploinsufficient-genes-clingen-v1
      :ggd:checksum: installed  file checksum: grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz.tbi checksum: 5fc9e77bea58d2ef96d6f48a5e977a18
      :ggd:checksum: metadata checksum record: grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz.tbi checksum: 5fc9e77bea58d2ef96d6f48a5e977a18 

      :ggd:checksum: installed  file checksum: grch37-haploinsufficient-genes-clingen-v1.bed.gz checksum: 287eb021cf209ed4711bb69f66e38391
      :ggd:checksum: metadata checksum record: grch37-haploinsufficient-genes-clingen-v1.bed.gz checksum: 287eb021cf209ed4711bb69f66e38391 

      :ggd:checksum: installed  file checksum: grch37-haploinsufficient-genes-clingen-v1.bed.gz.tbi checksum: 531f8c4dfd43e562cf0c81d2bceb96e0
      :ggd:checksum: metadata checksum record: grch37-haploinsufficient-genes-clingen-v1.bed.gz.tbi checksum: 531f8c4dfd43e562cf0c81d2bceb96e0 

      :ggd:checksum: installed  file checksum: grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz checksum: 0f347399371685e65df738b13e596f83
      :ggd:checksum: metadata checksum record: grch37-haploinsufficient-genes-clingen-v1.complement.bed.gz checksum: 0f347399371685e65df738b13e596f83 

      :ggd:install: ** Successful Checksum **

      :ggd:install: Checksum for grch37-microsatellites-ucsc-v1
      :ggd:checksum: installed  file checksum: grch37-microsatellites-ucsc-v1.bed.gz checksum: f15e697a24cd2fa0ce42d4a7682ae2ed
      :ggd:checksum: metadata checksum record: grch37-microsatellites-ucsc-v1.bed.gz checksum: f15e697a24cd2fa0ce42d4a7682ae2ed 

      :ggd:checksum: installed  file checksum: grch37-microsatellites-ucsc-v1.bed.gz.tbi checksum: 8c8dc0191b9f19c636ef13872ae15c80
      :ggd:checksum: metadata checksum record: grch37-microsatellites-ucsc-v1.bed.gz.tbi checksum: 8c8dc0191b9f19c636ef13872ae15c80 

      :ggd:install: ** Successful Checksum **

      :ggd:install: Install Complete


      :ggd:install: Installed file locations
      ======================================================================================================================

               GGD Package                                     Environment Variable(s)                                    
           ----------------------------------------------------------------------------------------------------
      -> grch37-haploinsufficient-genes-clingen-v1                  $ggd_grch37_haploinsufficient_genes_clingen_v1_dir                  


      Install Path: <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-haploinsufficient-genes-clingen-v1/1


           ----------------------------------------------------------------------------------------------------
      -> grch37-microsatellites-ucsc-v1                        $ggd_grch37_microsatellites_ucsc_v1_dir                       
                                                              $ggd_grch37_microsatellites_ucsc_v1_file                       


      Install Path: <conda root>/share/ggd/Homo_sapiens/GRCh37/grch37-microsatellites-ucsc-v1/1


           ---------------------------------------------------------------------------------------------------- 

      :ggd:install: To activate environment variables run `source activate base` in the environmnet the packages were installed in

      :ggd:install: NOTE: These environment variables are specific to the <env> conda environment and can only be accessed from within that environment
      ======================================================================================================================




      :ggd:install: Environment Variables
      *****************************

      Inactive or out-of-date environment variables:
      > $ggd_grch37_haploinsufficient_genes_clingen_v1_dir
      > $ggd_grch37_microsatellites_ucsc_v1_dir
      > $ggd_grch37_microsatellites_ucsc_v1_file

      To activate inactive or out-of-date vars, run:
      source activate base

      *****************************


      :ggd:install: DONE

.. note::

    To activate environment variables run:
    :code:`source activate base`


.. _ggd-install-example-4:

4. Successful install using the --file flag:
++++++++++++++++++++++++++++++++++++++++++++

If we had a txt file named :code:`data_package_file.txt` and the contents of the file is:

.. code-block:: 
  
    hg19-chromsizes-ggd-v1
    hg19-gaps-ucsc-v1
    hg19-cpg-islands-ucsc-v1

We could install each of those data packages at the same tile using the :code:`--file` flag.

.. note::
  
    If using a file to install data packages, the file needs to be formatted as a single column file with 
    each data package on its own line. 

.. code-block:: bash



    $ ggd install --file data_package_file.txt 

      

      :ggd:install: Looking for hg19-chromsizes-ggd-v1 in the 'ggd-genomics' channel

      :ggd:install: hg19-chromsizes-ggd-v1 exists in the ggd-genomics channel

      :ggd:install: hg19-chromsizes-ggd-v1 version 1 is not installed on your system

      :ggd:install: hg19-chromsizes-ggd-v1 has not been installed by conda


      :ggd:install: Looking for hg19-cpg-islands-ucsc-v1 in the 'ggd-genomics' channel

      :ggd:install: hg19-cpg-islands-ucsc-v1 exists in the ggd-genomics channel

      :ggd:install: hg19-cpg-islands-ucsc-v1 version 1 is not installed on your system

      :ggd:install: hg19-cpg-islands-ucsc-v1 has not been installed by conda


      :ggd:install: Looking for hg19-gaps-ucsc-v1 in the 'ggd-genomics' channel

      :ggd:install: hg19-gaps-ucsc-v1 exists in the ggd-genomics channel

      :ggd:install: hg19-gaps-ucsc-v1 version 1 is not installed on your system

      :ggd:install: hg19-gaps-ucsc-v1 has not been installed by conda

      :ggd:install: The hg19-chromsizes-ggd-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket

      :ggd:install: The hg19-cpg-islands-ucsc-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket

      :ggd:install: The hg19-gaps-ucsc-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket


      :ggd:install:   Attempting to install the following cached package(s):
        hg19-chromsizes-ggd-v1
        hg19-cpg-islands-ucsc-v1
        hg19-gaps-ucsc-v1


      :ggd:utils:bypass: Installing hg19-chromsizes-ggd-v1, hg19-cpg-islands-ucsc-v1, hg19-gaps-ucsc-v1 from the ggd-genomics conda channel

      Collecting package metadata: done
      Processing data: done

      ## Package Plan ##

        environment location: <env>

        added / updated specs:
          - hg19-chromsizes-ggd-v1
          - hg19-cpg-islands-ucsc-v1
          - hg19-gaps-ucsc-v1


      The following packages will be downloaded:

          package                    |            build
          ---------------------------|-----------------
          hg19-chromsizes-ggd-v1-1   |                1           6 KB  ggd-genomics
          hg19-cpg-islands-ucsc-v1-1 |                1           6 KB  ggd-genomics
          hg19-gaps-ucsc-v1-1        |                1           6 KB  ggd-genomics
          ------------------------------------------------------------
                                                 Total:          18 KB

      The following NEW packages will be INSTALLED:

        hg19-chromsizes-g~ ggd-genomics/noarch::hg19-chromsizes-ggd-v1-1-1
        hg19-cpg-islands-~ ggd-genomics/noarch::hg19-cpg-islands-ucsc-v1-1-1
        hg19-gaps-ucsc-v1  ggd-genomics/noarch::hg19-gaps-ucsc-v1-1-1



      Downloading and Extracting Packages
      hg19-chromsizes-ggd- | 6 KB      | ############################################################################ | 100% 
      hg19-cpg-islands-ucs | 6 KB      | ############################################################################ | 100% 
      hg19-gaps-ucsc-v1-1  | 6 KB      | ############################################################################ | 100% 
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      :ggd:install: Updating installed package list

      :ggd:install: Initiating data file content validation using checksum

      :ggd:install: Checksum for hg19-chromsizes-ggd-v1

      :ggd:install: ** Successful Checksum **

      :ggd:install: Checksum for hg19-cpg-islands-ucsc-v1

      :ggd:install: ** Successful Checksum **

      :ggd:install: Checksum for hg19-gaps-ucsc-v1

      :ggd:install: ** Successful Checksum **

      :ggd:install: Install Complete


      :ggd:install: Installed file locations
      ======================================================================================================================

               GGD Package                                     Environment Variable(s)                                    
           ----------------------------------------------------------------------------------------------------
      -> hg19-chromsizes-ggd-v1                            $ggd_hg19_chromsizes_ggd_v1_dir                           
                                                          $ggd_hg19_chromsizes_ggd_v1_file                           


      Install Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-chromsizes-ggd-v1/1


           ----------------------------------------------------------------------------------------------------
      ->  hg19-gaps-ucsc-v1                              $ggd_hg19_gaps_ucsc_v1_dir                              
                                                         $ggd_hg19_gaps_ucsc_v1_file                             


      Install Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-gaps-ucsc-v1/1


           ----------------------------------------------------------------------------------------------------
      -> hg19-cpg-islands-ucsc-v1                           $ggd_hg19_cpg_islands_ucsc_v1_dir                          
                                                           $ggd_hg19_cpg_islands_ucsc_v1_file                          


      Install Path: <conda root>/share/ggd/Homo_sapiens/hg19/hg19-cpg-islands-ucsc-v1/1


           ---------------------------------------------------------------------------------------------------- 

      :ggd:install: To activate environment variables run `source activate base` in the environmnet the packages were installed in

      :ggd:install: NOTE: These environment variables are specific to the <env> conda environment and can only be accessed from within that environment
      ======================================================================================================================




      :ggd:install: Environment Variables
      *****************************

      Inactive or out-of-date environment variables:
      > $ggd_hg19_chromsizes_ggd_v1_dir
      > $ggd_hg19_chromsizes_ggd_v1_file
      > $ggd_hg19_cpg_islands_ucsc_v1_dir
      > $ggd_hg19_cpg_islands_ucsc_v1_file
      > $ggd_hg19_gaps_ucsc_v1_dir
      > $ggd_hg19_gaps_ucsc_v1_file

      To activate inactive or out-of-date vars, run:
      source activate base

      *****************************


      :ggd:install: DONE


.. note::

    To activate environment variables run:
    :code:`source activate base`



5. Successful install with --prefix flag:
+++++++++++++++++++++++++++++++++++++++++

You can install a data package into an existing conda environment using the :code:`--prefix` flag. This is useful if you 
want to store all instances of data in one environment rather than having multiple instances of the data installed and spread 
throughout your system. 

For this example, let's say we have a conda environment called :code:`data` where we store all of our data. We can install a 
data package into that conda environment without having to be in the conda environment using the :code:`--prefix` flag. 

.. code-block:: bash

    $ ggd install grch37-microsatellites-ucsc-v1 --prefix data


      :ggd:install: Looking for grch37-microsatellites-ucsc-v1 in the 'ggd-genomics' channel

      :ggd:install: grch37-microsatellites-ucsc-v1 exists in the ggd-genomics channel

      :ggd:install: grch37-microsatellites-ucsc-v1 version 1 is not installed on your system

      :ggd:install: grch37-microsatellites-ucsc-v1 has not been installed by conda

      :ggd:install: The grch37-microsatellites-ucsc-v1 package is uploaded to an aws S3 bucket. To reduce processing time the package will be downloaded from an aws S3 bucket


      :ggd:install:   Attempting to install the following cached package(s):
        grch37-microsatellites-ucsc-v1


      :ggd:utils:bypass: Installing grch37-microsatellites-ucsc-v1 from the ggd-genomics conda channel

      Collecting package metadata: done
      Processing data: done

      ## Package Plan ##

        environment location: <data environment>

        added / updated specs:
          - grch37-microsatellites-ucsc-v1


      The following packages will be downloaded:

          package                    |            build
          ---------------------------|-----------------
          grch37-microsatellites-ucsc-v1-1|                1           7 KB  ggd-genomics
          ------------------------------------------------------------
                                                 Total:           7 KB

      The following NEW packages will be INSTALLED:

        grch37-microsatel~ ggd-genomics/noarch::grch37-microsatellites-ucsc-v1-1-1



      Downloading and Extracting Packages
      grch37-microsatellit | 7 KB      | ############################################################################ | 100% 
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      :ggd:install: Updating package metadata in user defined prefix

      :ggd:install: Updating installed package list

      :ggd:install: Initiating data file content validation using checksum

      :ggd:install: Checksum for grch37-microsatellites-ucsc-v1
      :ggd:checksum: installed  file checksum: grch37-microsatellites-ucsc-v1.bed.gz checksum: f15e697a24cd2fa0ce42d4a7682ae2ed
      :ggd:checksum: metadata checksum record: grch37-microsatellites-ucsc-v1.bed.gz checksum: f15e697a24cd2fa0ce42d4a7682ae2ed 

      :ggd:checksum: installed  file checksum: grch37-microsatellites-ucsc-v1.bed.gz.tbi checksum: 8c8dc0191b9f19c636ef13872ae15c80
      :ggd:checksum: metadata checksum record: grch37-microsatellites-ucsc-v1.bed.gz.tbi checksum: 8c8dc0191b9f19c636ef13872ae15c80 

      :ggd:install: ** Successful Checksum **

      :ggd:install: Install Complete


      :ggd:install: Installed file locations
      ======================================================================================================================

               GGD Package                                     Environment Variable(s)                                    
           ----------------------------------------------------------------------------------------------------
      -> grch37-microsatellites-ucsc-v1                        $ggd_grch37_microsatellites_ucsc_v1_dir                       
                                                              $ggd_grch37_microsatellites_ucsc_v1_file                       


      Install Path: <data environment>/share/ggd/Homo_sapiens/GRCh37/grch37-microsatellites-ucsc-v1/1


           ---------------------------------------------------------------------------------------------------- 

      :ggd:install: To activate environment variables run `source activate base` in the environmnet the packages were installed in

      :ggd:install: NOTE: These environment variables are specific to the <data environment> conda environment and can only be accessed from within that environment
      ======================================================================================================================




      :ggd:install: DONE


.. note::

    The environment variables for any new data package installed into a different environment then the one you are currently in are NOT available for use. 
    That is, the environment variables are local to the conda environment in which the the data package was installed. To access this data use the 
    :code:`ggd get-files` tool with the :code:`--prefix` flag. See :ref:`ggd get-files`<ggd-get-files>, 




