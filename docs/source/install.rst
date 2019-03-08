.. _ggd-install:

ggd install
===========

[:ref:`Click here to return to the home page <home-page>`]

ggd install is used to install a ggd package from the Anaconda cloud. ggd install determines your file system and ensures
a proper install. If the package fails to install for some reason it will clean up the failed install.

    .. note::

        Running :code:`conda install <package>` will work, however, it will only install the package and will not
        provide file and system management. **Please use** :code:`ggd install <package>` **when installing a ggd data package**.


Using ggd install
-----------------
Use :code:`ggd install` to install a data package hosted by ggd.
Running :code:`ggd install -h` will give you the following message:

Install arguments:

-h, --help                      show this help message and exit

/name                           (Positional) the name of the recipe to install.
                                ('/' indicates a placeholder and is not part of the argument name)

-c, --channel                   (Optional) The ggd channel the desired recipe is stored in.(Default = genomics)

-v VERSION, --version VERSION   (Optional) A specific ggd package version to install. If the -v
                                flag is not used the latest version will be installed.


Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments:

* *name:* The :code:`name` represents the name of the ggd package to download and is required. If the name
  provided is not in the ggd channel it will not be downloaded, and the user will be informed.

Optional arguments:

* *-c:* The :code:`-c` flag represents the ggd channel. The default channel is *genomics*. If the data package
  you want to install is in a different ggd channel you will need to supply the channel name using this flag.

  For example, if the data was located in the 'proteomics' channel, you would use::

    ggd install <package> -c proteomics

* *-v:* The :code:`-v` flag represents a specific ggd-version for a desired package to be installed. If you want version 2 of
  a specific genomic data package you would run :code:`ggd install <package> -v 2`. This flag is not required.


    .. note::
    
        Durring the installation you will see a multiple progress spinners. The time it takes to install the data pacakge 
        is dependent on how big the data package is being installed. When you see: **Executing Transaction |-** you are 
        in the final stages of installation, however, this stage takes the longest. Please be patient as the package is 
        being installed, processed, and curated. 


Examples
--------

1. Failed install example:
++++++++++++++++++++++++++

::

    $ ggd install hg19-ga

      Looking for hg19-ga in the 'ggd-genomics' channel

      'hg19-ga' was not found in ggd-genomics
      You can search for recipes using the ggd search tool:
         'ggd search -t hg19-ga'

2. Successful install example:
++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd install hg19-gaps

      Looking for hg19-gaps in the 'ggd-genomics' channel

      hg19-gaps exists in ggd-genomics

      hg19-gaps is not installed on your system

      hg19-gaps has not been installed by conda

      Installing hg19-gaps
      Solving environment:

       ## Package Plan ##

       environment location: <conda root>

         added / updated specs:
            - hg19-gaps


      The following packages will be downloaded:

         package                    |     build
         ---------------------------|----------
         hg19-gaps-1                |         0      6 KB  ggd-genomics

      The following NEW packages will be INSTALLED:

         hg19-gaps: 1-0 ggd-genomics


      Downloading and Extracting Packages
      hg19-gaps-1          | 6 KB      | ####################### | 100%
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      DONE
