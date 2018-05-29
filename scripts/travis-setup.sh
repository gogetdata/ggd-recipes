#!/bin/bash

set -exo pipefail 

# NOTE: much of this is taken from bioconda.
if [[ $TRAVIS_OS_NAME = "linux" ]]; then
	#curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
	#curl -O https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh
	curl -O https://repo.continuum.io/miniconda/Miniconda3-4.3.11-Linux-x86_64.sh
	sudo bash Miniconda3-4.3.11-Linux-x86_64.sh -b -p /anaconda/
	sudo chown -R $USER /anaconda/
	curl -Lo /anaconda/bin/check-sort-order https://github.com/gogetdata/ggd-utils/releases/download/v0.0.3/check-sort-order-linux_amd64
else
	#curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
	#curl -O https://repo.continuum.io/miniconda/Miniconda3-4.3.31-MacOSX-x86_64.sh
	curl -O https://repo.continuum.io/miniconda/Miniconda3-4.3.11-MacOSX-x86_64.sh
	sudo bash Miniconda3-4.3.11-MacOSX-x86_64.sh -b -p /anaconda/
	sudo chown -R $USER /anaconda/
	curl -Lo /anaconda/bin/check-sort-order https://github.com/gogetdata/ggd-utils/releases/download/v0.0.3/check-sort-order-darwin_amd64
fi

chmod +x /anaconda/bin/check-sort-order
mkdir -p /anaconda/conda-bld/{linux,osx}-64
export PATH=/anaconda/bin:$PATH
conda install -y conda-build
conda update -y conda
conda config --add channels bioconda
conda config --add channels conda-forge

## Install bioconda-utils (https://github.com/bioconda/bioconda-recipes/blob/master/.circleci/setup.sh)
#conda install -y git pip --file https://raw.githubusercontent.com/bioconda/bioconda-utils/cb3-migration/bioconda_utils/bioconda_utils-requirements.txt
#pip install git+https://github.com/bioconda/bioconda-utils.git
#pip install -e git++https://github.com/bioconda/bioconda-utils.git@cb3-migration#egg=mikec
conda install -y -c bioconda -c conda-forge bioconda-utils

conda install -y conda-build anaconda-client
pip install -U git+git://github.com/gogetdata/ggd-cli.git
conda install -y "gsort>=0.0.2" samtools htslib zlib
conda info -a #for debugging
