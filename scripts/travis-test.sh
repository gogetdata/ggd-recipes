#!/bin/bash
set -eo pipefail
export PATH=/anaconda/bin:$PATH
check-sort-order --help

conda-build-all \
	--inspect-channels=ggd-alpha \
	recipes/

ls $(conda info --root)/conda-bld/linux-64/*.bz2
