#!/bin/bash

set -eo pipefail 

# NOTE: much of this is taken from bioconda.
if [[ $TRAVIS_OS_NAME = "linux" ]]; then
	curl -O http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
	sudo bash Miniconda2-latest-Linux-x86_64.sh -b -p /anaconda/
	sudo chown -R $USER /anaconda/
	mkdir -p /anaconda/conda-bld/{linux,osx}-64
	export PATH=/anaconda/bin:$PATH
	conda config --add channels bioconda
	curl -o /anaconda/bin/check-sort-order https://github.com/gogetdata/ggd-utils/releases/download/v0.0.1/check-sort-order-linux_amd64
	chmod +x /anaconda/bin/check-sort-order
	conda install -y conda-build anaconda-client

else
	# http://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh
	echo "TODO!!!"
	exit 22
fi
