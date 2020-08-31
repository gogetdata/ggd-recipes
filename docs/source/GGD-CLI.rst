.. _ggd_cli_page:


GGD Commands
============

[:ref:`Click here to return to the home page <home-page>`]

**To see and/or search for data packages available through GGD, see:** :ref:`Available data packages <recipes>`

The ggd command line interface (cli) has multiple tools for data access and local management. Below you can find a short
description of each tool, as well as links to specific pages about each. 

Tabs for each tool are also available on the left tab bar.  

+-------------------------------------------------+--------------------------------------------------------------------+
|    Command                                      | Description                                                        |
+=================================================+====================================================================+
| :ref:`ggd search <ggd-search>`                  |  Search for a ggd data package                                     |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd predict-path <ggd-predict-path>`      | Predict the file path of a data package that has not been          |
|                                                 | installed yet (Good for workflows like Snakemake)                  |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd install <ggd-install>`                | Install ggd data package(s)                                        |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd uninstall <ggd-uninstall>`            | Uninstall a ggd data package(s)                                    |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd list <ggd-list>`                      | List the installed data packages (in a specific environment)       |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd get-files <ggd-get-files>`            | get the files for an installed ggd package                         |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd pkg-info <ggd-pkg-info>`              | Show a specific ggd package's info                                 |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd show-env <ggd-show-env>`              | Show the ggd specific environment variables                        |
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd make-recipe <ggd-make-recipe>`        | Create a ggd recipe from a bash script                             | 
+-------------------------------------------------+--------------------------------------------------------------------+
| :ref:`ggd check-recipe <ggd-check-recipe>`      | Check/test a ggd recipe                                            | 
+-------------------------------------------------+--------------------------------------------------------------------+



Command links:

.. toctree::
	:maxdepth: 2
  
	ggd-search
	install
	predict-path
	uninstall
	list
	list-file
	pkg-info
	show-env
	make-recipe
	check-recipe
