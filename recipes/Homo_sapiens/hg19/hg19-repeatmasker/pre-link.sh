#!/bin/bash
set -eo pipefail -o nounset

CONDA_ROOT=$(conda info --root)

pushd `dirname $0` > /dev/null
HERE=`pwd`
popd > /dev/null

mkdir -p $CONDA_ROOT/share/ggd/Homo_sapiens/hg19/
(cd $CONDA_ROOT/share/ggd/Homo_sapiens/hg19/ && bash $HERE/../info/recipe/recipe.sh)

echo 'SUCCESS!'
