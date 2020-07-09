#!/bin/bash

set -exo pipefail 

WORKSPACE=$(pwd)

# Set path
#echo "export PATH=$WORKSPACE/anaconda/bin:$PATH" >> $BASH_ENV
#source $BASH_ENV

cat >> $BASH_ENV <<EOF
# Set path
export PATH="${WORKSPACE}/anaconda/bin:${PATH}"
if [ -f "${WORKSPACE}/anaconda/etc/profile.d/conda.sh" ] ; then
    . "${WORKSPACE}/anaconda/etc/profile.d/conda.sh"
fi
EOF
. $BASH_ENV

## Get bioconda version requirements
curl -s https://raw.githubusercontent.com/bioconda/bioconda-common/master/common.sh > .circleci/bioconda-common.sh
source .circleci/bioconda-common.sh

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

    curl -L -O https://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VER-$tag-x86_64.sh
    sudo bash Miniconda3-$MINICONDA_VER-$tag-x86_64.sh -b -p $WORKSPACE/anaconda/
    sudo chown -R $USER $WORKSPACE/anaconda/
    . $BASH_ENV
    conda activate base

    mkdir -p $WORKSPACE/anaconda/conda-bld/$tag-64

    # step 2: setup channels
    conda config --system --add channels defaults
    conda config --system --add channels bioconda
    conda config --system --add channels conda-forge
    conda config --system --add channels ggd-genomics

    # step 3: install ggd requirements 
    conda install -y --file requirements.txt 

    ## Install ggd-cli
    pip install -U git+git://github.com/gogetdata/ggd-cli 

    ## Temporarily use the cli_update 
    ## pip install -U git+git://github.com/gogetdata/ggd-cli@cli_update 

    # step 4: install requirments from git repos
    ## Install bioconda-utils

    ## Temporarily use an older version of bioconda utils
    BIOCONDA_UTILS_TAG=v0.16.17
    conda install -y --file https://raw.githubusercontent.com/bioconda/bioconda-utils/$BIOCONDA_UTILS_TAG/bioconda_utils/bioconda_utils-requirements.txt 
    pip install git+https://github.com/bioconda/bioconda-utils.git@$BIOCONDA_UTILS_TAG

    # step 5: cleanup
    #conda clean -y --all

    # step 6: download conda_build_config.yaml from conda_forge and put into conda root (Required for using bioconda-utils build)
#    cur=`pwd`
#    CONDA_ROOT=$(conda info --root)
#    cd $CONDA_ROOT
#    curl -O https://raw.githubusercontent.com/conda-forge/conda-forge-pinning-feedstock/master/recipe/conda_build_config.yaml
#    cd $cur

    # step 7: set up local channels
    # Add local channel as highest priority
    mkdir -p $WORKSPACE/anaconda/conda-bld/{noarch,linux-64,osx-64}
    conda index $WORKSPACE/anaconda/conda-bld/
    conda config --system --add channels file://$WORKSPACE/anaconda/conda-bld
fi

conda config --get

ls $WORKSPACE/anaconda/conda-bld
ls $WORKSPACE/anaconda/conda-bld/noarch

