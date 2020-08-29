.. _ggd-uninstall:

ggd uninstall
=============

[:ref:`Click here to return to the home page <home-page>`]

:code:`ggd uninstall` is used to uninstall ggd package(s) from your local conda environment that has been installed by
ggd. It ensures a correct uninstall of the data package along with removal of additional files created during installation.

    .. note::

        Running :code:`conda uninstall <package>` will work, however, it will only uninstall the package and will not
        provide file and system management. **Please use** :code:`ggd uninstall <package>` **when uninstalling a ggd data package**.


Using ggd uninstall
-------------------
Use :code:`ggd uninstall` to uninstall a ggd data package previously installed using  :code:`ggd install`.
Running :code:`ggd uninstall -h` will give you the following message:


Uninstall arguments: 

+------------------------+-------------------------------------------------------------------------------------+
| ggd uninstall          | Use ggd to uninstall a ggd data package installed in the current conda              |
|                        | environment                                                                         |
+========================+=====================================================================================+
| ``-h``, ``--help``     | show this help message and exit                                                     |
+------------------------+-------------------------------------------------------------------------------------+
| ``names``              | the name(s) of the ggd package(s) to uninstall                                      |           
+------------------------+-------------------------------------------------------------------------------------+
| ``-c``, ``--channel``  | (Optional) The ggd channel the desired recipe is stored in.(Default = genomics)     |
+------------------------+-------------------------------------------------------------------------------------+


Additional argument explanation: 
++++++++++++++++++++++++++++++++

Required arguments: 

* *names:* The :code:`names` is the name or names of the ggd data package(s) to uninstall.

Optional arguments: 

* *-c:* The :code:`-c` flag represents the ggd channel. The default channel is *genomics*. If the data package you want to uninstall
  is in a different ggd channel you will need to supply the channel name using this flag. 

    .. note::

        You need to be in the conda environment/prefix in which the data has been installed in order to uninstall it. 
        If the data packages you are trying to uninstall is not in the current/active conda environment it will not be 
        uninstalled, or it will uninstall the package that is in that environment which would not be the intent.


Examples
--------

1. Failed uninstall example:
++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd uninstall hg19-ga

      :ggd:uninstall: Checking for installation of hg19-ga

      :ggd:uninstall: hg19-ga is not in the ggd-genomics channel

      :ggd:uninstall: Unable to find any package similar to the package entered. Use 'ggd search' or 'conda find' to identify the right package

      :ggd:uninstall: This package may not be installed on your system


2. Successful uninstall example:
++++++++++++++++++++++++++++++++

.. code-block:: bash

    $ ggd uninstall hg19-gaps-ucsc-v1

      :ggd:uninstall: Checking for installation of hg19-gaps-ucsc-v1

      :ggd:uninstall: hg19-gaps-ucsc-v1 is installed by conda on your system

      :ggd:uninstall: Uninstalling hg19-gaps-ucsc-v1
      Collecting package metadata (repodata.json): done
      Solving environment: done

      ## Package Plan ##

        environment location: <env>

        removed specs:
          - hg19-gaps-ucsc-v1


      The following packages will be REMOVED:

        hg19-gaps-ucsc-v1-1-1


      Preparing transaction: done
      Verifying transaction: done
      Executing transaction: done

      :ggd:uninstall: Removing hg19-gaps-ucsc-v1 version 1 file(s) from ggd recipe storage

      :ggd:uninstall: Deleting 9 items of hg19-gaps-ucsc-v1 version 1 from your conda root

      :ggd:env: Removing the ggd_hg19_gaps_ucsc_v1_dir environment variable

      :ggd:env: Removing the ggd_hg19_gaps_ucsc_v1_file environment variable

      :ggd:uninstall: Updating installed package list

      :ggd:uninstall: DONE

