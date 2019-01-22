#!/bin/bash
## Much of this is taken from bioconda: https://github.com/bioconda/bioconda-utils/blob/master/.circleci/setup.sh

set -exo pipefail 

WORKSPACE=$(pwd)

# Set path
echo "export PATH=$WORKSPACE/anaconda/bin:$PATH" >> $BASH_ENV
source $BASH_ENV

# setup conda and dependencies 
if [[ ! -d $WORKSPACE/anaconda ]]; then
    mkdir -p $WORKSPACE

    # step 1: download and install anaconda
    if [[ $OSTYPE == darwin* ]]; then
        tag="MacOSX"
        tag2="darwin"
    elif [[ $OSTYPE == linux* ]]; then
        tag="Linux"
        tag2="linux"
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi

    curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-$tag-x86_64.sh
    sudo bash Miniconda3-latest-$tag-x86_64.sh -b -p $WORKSPACE/anaconda/
    sudo chown -R $USER $WORKSPACE/anaconda/
    curl -Lo $WORKSPACE/anaconda/bin/check-sort-order https://github.com/gogetdata/ggd-utils/releases/download/v0.0.3/check-sort-order-$tag2\_amd64

    chmod +x $WORKSPACE/anaconda/bin/check-sort-order
    mkdir -p $WORKSPACE/anaconda/conda-bld/$tag-64


    # step 2: setup channels
    conda config --system --add channels defaults
    conda config --system --add channels bioconda
    conda config --system --add channels conda-forge
    conda config --system --add channels ggd-genomics

    
    # step 3: install ggd requirements 
    conda install -y --file requirements.txt 


    # step 4: install requirments from git repos
        ## Install bioconda-utils (https://github.com/bioconda/bioconda-recipes/blob/master/.circleci/setup.sh)
        # conda install -y -c bioconda -c conda-forge bioconda-utils
    ### Using master branch from git repo

    conda install -y --file .circleci/requirements_bioconda_utils.txt
    #conda install -y --file https://raw.githubusercontent.com/bioconda/bioconda-utils/master/bioconda_utils/bioconda_utils-requirements.txt
    pip install git+https://github.com/bioconda/bioconda-utils.git
    ## Install ggd-cli
    #pip install -U git+git://github.com/gogetdata/ggd-cli.git
    #pip install -U git+git://github.com/gogetdata/ggd-cli.git@mikec-update # Temp use mikec-update branch
	#conda install -y --file https://raw.githubusercontent.com/mikecormier/ggd-cli/master/requirements.txt
    #pip install -U git+git://github.com/mikecormier/ggd-cli # Temp use mikecormier ggd-cli 
    conda install -y --file https://raw.githubusercontent.com/gogetdata/ggd-cli/master/requirements.txt
    pip install -U git+git://github.com/gogetdata/ggd-cli 



    # step 5: cleanup
    conda clean -y --all


    # step 6: download conda_build_config.yaml from conda_forge and put into conda root (Required for using bioconda-utils build)
    cur=`pwd`
    CONDA_ROOT=$(conda info --root)
    cd $CONDA_ROOT
    curl -O https://raw.githubusercontent.com/conda-forge/conda-forge-pinning-feedstock/master/recipe/conda_build_config.yaml
    #touch conda_build_config.yaml
    cd $cur


    # Add local channel as highest priority
    conda index $WORKSPACE/anaconda/conda-bld/linux-64 $WORKSPACE/anaconda/conda-bld/osx-64 $WORKSPACE/anaconda/conda-bld/noarch
    conda config --system --add channels file://$WORKSPACE/anaconda/conda-bld
fi

conda config --get

ls $WORKSPACE/anaconda/conda-bld
ls $WORKSPACE/anaconda/conda-bld/noarch



