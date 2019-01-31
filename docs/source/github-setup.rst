.. _setup-github:

Setting up with Github
======================

A github account is required in order to contribute a data package to ggd. If you do not have a
github account it is easy to create one. (Note: Your github account does not need to be connected
to ggd in order to work)

* Go to `github.com <https://github.com/>`_ and sign up for an account. (Accounts are free)

* Once you have an account you will need to fork the `ggd-recipes <https://github.com/gogetdata/ggd-recipes>`_
  github repo. This repository is where the ggd data recipes are collected.

  * In the top right hand corner of the `ggd-recipes <https://github.com/gogetdata/ggd-recipes>`_ page you will
      see a button called **fork**. When you have pressed the button it will ask you where to put the fork. Select
      your github account.

  * **ggd-recipes** will now be a repository attached to your account. (github.com/<github username>/ggd-recipes)

* You will then need to clone the forked ggd-recipes repo to the machine that you are working on.

  * On you machine navigate to a directory were you want to download the forked ggd-recipes repo.

  * **NOTE:** `git` is a required software package. If you do not have it downloaded on your system run::

    $ conda install -c anaconda git

  * **NOTE:** conda is required as well. If you do not have conda installed on your system see :ref:`Using GGD <using-ggd>`
      to install conda and the required software packages on your system. You can then return to this page and continue.

* Clone the forked repository to the current location on your machine.

  * ``<USERNAME>`` is your github account username. This is where the ggd-recipes repo was forked.

  ::

    $ git clone https://github.com/<USERNAME>/ggd-recipes.git


* Move into the ggd-recipes directory::

    $ cd ggd-recipes/

* Add the original ggd-recipes repo as an upstream remote repo to the one just added to your machine. This
  will make it easier to update your forked repo with the original, upstream repository.

  ::

    $ git remote add upstream https://github.com/gogetdata/ggd-recipes.git


You have now set up a forked ggd-recipes repository on your machine, which you will use to add data packages to ggd.
