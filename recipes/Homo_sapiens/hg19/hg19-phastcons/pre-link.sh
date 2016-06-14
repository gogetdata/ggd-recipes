#!/bin/bash
set -eo pipefail -o nounset

export CONDA_ROOT=$(conda info --root)

pushd `dirname $0` > /dev/null
HERE=`pwd`
popd > /dev/null

export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/hg19/hg19-phastcons
mkdir -p $RECIPE_DIR
(cd $RECIPE_DIR && bash $HERE/../info/recipe/recipe.sh)

echo 'SUCCESS!'
