#!/bin/bash

set -exo pipefail 

# NOTE: much of this is taken from bioconda.
if [[ $TRAVIS_OS_NAME = "linux" ]]; then
	curl -O http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
	sudo bash Miniconda2-latest-Linux-x86_64.sh -b -p /anaconda/
	sudo chown -R $USER /anaconda/
	curl -Lo /anaconda/bin/check-sort-order https://github.com/gogetdata/ggd-utils/releases/download/v0.0.3/check-sort-order-linux_amd64


else
	curl -O http://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh
	sudo bash Miniconda2-latest-MacOSX-x86_64.sh -b -p /anaconda/
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
conda install -y conda-build-all --channel conda-forge
conda install -y conda-build anaconda-client
pip install -U git+git://github.com/gogetdata/ggd-cli.git
conda install -y "gsort>=0.0.2" samtools htslib zlib
