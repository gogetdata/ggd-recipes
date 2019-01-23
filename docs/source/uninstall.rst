.. _ggd-uninstall:

ggd uninstall
=============

ggd uninstall is used to uninstall a ggd pacakge from you local machine. It ensures a correct uninstall of the
data package along with removal of aditional files created during installation, with additional clean-up steps.
NOTE: running :code:`conda uninstall <package>` will work, however, it will only uninstall the package and won't 
provide file and system managment. Please use :code:`ggd uninstall <package>` when uninstalling a ggd data package.


Using ggd uninstall
-------------------
Use :code:`ggd uninstall` to uninstall a ggd data package previously installed using  :code:`ggd install`. 
Running :code:`ggd uninstall -h` will give you the following message:

.. code-block:: bash

    positional arguments:
        name                  the name of the recipe to install

    optional arguments:
        -h, --help            show this help message and exit
        -c {genomics}, --channel {genomics}
                              The ggd channel the desired recipe is stored in.(Default = genomics)

The :code:`name` is the name of the ggd data package to uninstall.

The :code:`-c` flag represents the ggd channel. The default channel is *genomics*. If the data package you want to uninstall
is in a different ggd channel you will need to supply the channel name using this flag.
Example: :code:`ggd uninstall <package> -c proteomics`

Example
-------

1. Failed uninstall example:
++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd uninstall hg19-ga

      Checking for instalation of hg19-ga
     
      hg19-ga is not in the ggd-genomics channel
     
      Packages installed on your system that are similar include:
             Package         Channel
             -hg19-gaps      ggd-genomics
     
      If one of these packages is the desired package to uninstall please rerun ggd uninstall with the desired package name and correct ggd channel name
     
      Note: If the the package is not a part of a ggd channel run 'conda uninstall <pkg>' to uninstall
     
      GGD channels include: genomics, etc.

2. Successful uninstall example:
++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd uninstall hg19-gaps 

      Checking for instalation of hg19-gaps
     
      hg19-gaps is installed by conda on your system
     
      Uninstalling hg19-gaps
      Solving environment: done
     
      ## Package Plan ##
     
      environment location: <conda root>
     
      removed specs: 
        - hg19-gaps
     
     
      The following packages will be REMOVED:
     
        hg19-gaps: 1-0 ggd-genomics
     
      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done
     
      Removing hg19-gaps version 1 file(s) from ggd recipe storage
     
      Deleteing 2 items of hg19-gaps version 1 from your conda root
     
      DONE


