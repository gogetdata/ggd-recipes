#!/bin/bash
set -eo pipefail -o nounset

if [[ -z $(conda info --envs | grep "*" | grep -o "\/.*") ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants-v1/1
elif [[ $(conda info --envs | grep "*" | grep -o "\/.*") == "base" ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants-v1/1
else
    env_dir=$(conda info --envs | grep "*" | grep -o "\/.*")
    export CONDA_ROOT=$env_dir
    export RECIPE_DIR=$env_dir/share/ggd/Homo_sapiens/GRCh37/grch37-esp-variants-v1/1
fi

PKG_DIR=`find "$CONDA_ROOT/pkgs/" -name "$PKG_NAME-$PKG_VERSION*" | grep -v ".tar.bz2" |  grep "$PKG_VERSION.*$PKG_BUILDNUM$"`

if [ -d $RECIPE_DIR ]; then
    rm -r $RECIPE_DIR
fi

mkdir -p $RECIPE_DIR

recipe_env_name="ggd_grch37-esp-variants-v1"
recipe_env_name="$(echo "$recipe_env_name" | sed 's/-/_/g')"

activate_dir="$env_dir/etc/conda/activate.d"
deactivate_dir="$env_dir/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_name">> $deactivate_dir/env_vars.sh

(cd $RECIPE_DIR && bash $PKG_DIR/info/recipe/recipe.sh)

cd $RECIPE_DIR

## Iterate over new files and replace file name with data package name and data version  
for f in *; do
    ext="${f#*.}"
    filename="{f%%.*}"
    (mv $f "grch37-esp-variants-v1.$ext")
done

echo 'Recipe successfully built!'
