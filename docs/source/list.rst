.. _ggd-list:

ggd list
========

[:ref:`Click here to return to the home page <home-page>`]

The :code:`ggd list` command is used to list the installed ggd data packages in a specific conda environment. This 
command is similar to :code:`conda list`, but is specific for ggd data packages. 

Using ggd list
--------------
Use :code:`ggd list` to list ggd data package installed in the current or specific conda environment.
Running :code:`ggd list -h` will give you the following message:


List arguments: 

+-------------------------------+----------------------------------------------------------------------------+
| ggd list                      | Get a list of ggd data packages installed in the current or                |
|                               | specified conda prefix/environment.                                        |
+===============================+============================================================================+
| -h, --help                    | show this help message and exit                                            |
+-------------------------------+----------------------------------------------------------------------------+
| -p, --pattern                 | (Optional) pattern to match the name of the ggd data package.              |
+-------------------------------+----------------------------------------------------------------------------+
| --prefix                      | (Optional) The name or the full directory path to a                        |
|                               | conda environment where a ggd recipe is stored. (Only                      |
|                               | needed if listing data files not in the current environment)               |
+-------------------------------+----------------------------------------------------------------------------+



Additional argument explanation: 
++++++++++++++++++++++++++++++++

Optional arguments: 

* *-p:* The :code:`-p` flag is used to list a specific installed data package. If :code:`-p` is not used, all installed data packages will be displayed.

* *--prefix:* :code:`--prefix` flag is used to list the installed data packages for a specific conda environment/prefix. If not set
  the data packages for the current environment will be listed


Examples
--------

1. List all installed data packages:
++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd list

      # Packages in environment: <env>
      #
      ------------------------------------------------------------------------------------------------------------------------
          Name                                Pkg-Version Pkg-Build   Channel         Environment-Variables
      ------------------------------------------------------------------------------------------------------------------------
      -> grch37-haploinsufficient-genes-clingen-v1    1         1   ggd-genomics     $ggd_grch37_haploinsufficient_genes_clingen_v1_dir     

      -> hg19-chromsizes-ggd-v1                       1         1    ggd-genomics    $ggd_hg19_chromsizes_ggd_v1_dir, $ggd_hg19_chromsizes_ggd_v1_file
 
      -> hg19-gaps-ucsc-v1                            1         1    ggd-genomics    $ggd_hg19_gaps_ucsc_v1_dir, $ggd_hg19_gaps_ucsc_v1_file  

      ...

      # To use the environment variables run `source activate base`
      # You can see the available ggd data package environment variables by running `ggd show-env`



2. List a specific installed data package using a pattern:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd list -p chromsizes

      # Packages in environment: <env>
      #
      ------------------------------------------------------------------------------------------------------------------------
          Name                                Pkg-Version Pkg-Build   Channel         Environment-Variables
      ------------------------------------------------------------------------------------------------------------------------
      -> hg19-chromsizes-ggd-v1                      1         1   ggd-genomics $ggd_hg19_chromsizes_ggd_v1_dir, $ggd_hg19_chromsizes_ggd_v1_file

      # To use the environment variables run `source activate base`
      # You can see the available ggd data package environment variables by running `ggd show-env`


3. List installed packages in a different prefix:
+++++++++++++++++++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd list --prefix data

      # Packages in environment: <data environment>
      #
      ------------------------------------------------------------------------------------------------------------------------
          Name                                Pkg-Version Pkg-Build   Channel         Environment-Variables
      ------------------------------------------------------------------------------------------------------------------------
      -> grch37-chromsizes-ggd-v1                    1         1   ggd-genomics        $ggd_grch37_chromsizes_ggd_v1_dir, $ggd_grch37_chromsizes_ggd_v1_file

      -> grch37-eiee-genes-ostrander-v1              1         1   ggd-genomics        $ggd_grch37_eiee_genes_ostrander_v1_dir          

      -> grch37-microsatellites-ucsc-v1              1         1   ggd-genomics        $ggd_grch37_microsatellites_ucsc_v1_dir, $ggd_grch37_microsatellites_ucsc_v1_file

      ...

      # The environment variables are only available when you are using the '<data environment>' conda environment.









