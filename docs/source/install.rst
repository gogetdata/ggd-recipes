.. _ggd-install:

ggd install
===========

ggd install is used to install a ggd pacakge from the Anacond cloud. It process your file system and ensure
a proper install. If the package fails to install for some reason it will clean up the failed install.
**NOTE:** running :code:`conda install <package>` will work, however, it will only install the package and won't 
provide file and system managment. Please use :code:`ggd install <package>` when installing a ggd data package.


Using ggd install
-----------------
Use :code:`ggd install` to install a data package hosted by ggd. 
Running :code:`ggd install -h` will give you the following message:

.. code-block:: bash

    positional arguments:
        name                  the name of the recipe to install

    optional arguments:
        -h, --help            show this help message and exit
        -c {genomics}, --channel {genomics}
                              The ggd channel the desired recipe is stored in.(Default = genomics)
        -v VERSION, --version VERSION
                              A specific ggd package version to install. If the -v
                              flag is not used the latest version will be installed.

Simply, the :code:`name` is the field that is required and represents the name of the ggd package to download. If the name 
provided is not in the ggd channel it will not be downloaded, and the user will be informed. 

The :code:`-c` flag represents the ggd channel. The default channel is *genomics*. If the data package you want to install
is in a different ggd channel you will need to supply the channel name using this flag.
Example: :code:`ggd install <package> -c proteomics`

The :code:`-v` flag represents a specific ggd-version for a desired package to be installed. If you want version 2 of 
a specific genomic data package you would run :code:`ggd install <package> -v 2`. This flag is not required

Example
-------

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
    
         package                    |            build
         ---------------------------|-----------------
         hg19-gaps-1                |                0           6 KB  ggd-genomics
    
      The following NEW packages will be INSTALLED:
    
         hg19-gaps: 1-0 ggd-genomics
    
    
      Downloading and Extracting Packages
      hg19-gaps-1          | 6 KB      | ############################################################################################ | 100% 
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done
     
      DONE


