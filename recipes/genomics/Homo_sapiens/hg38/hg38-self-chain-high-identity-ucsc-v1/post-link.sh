#!/bin/bash
set -eo pipefail -o nounset

if [[ -z $(conda info --envs | grep "*" | grep -o "\/.*") ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/hg38/hg38-self-chain-high-identity-ucsc-v1/1
elif [[ $(conda info --envs | grep "*" | grep -o "\/.*") == "base" ]]; then
    export CONDA_ROOT=$(conda info --root)
    env_dir=$CONDA_ROOT
    export RECIPE_DIR=$CONDA_ROOT/share/ggd/Homo_sapiens/hg38/hg38-self-chain-high-identity-ucsc-v1/1
else
    env_dir=$(conda info --envs | grep "*" | grep -o "\/.*")
    export CONDA_ROOT=$env_dir
    export RECIPE_DIR=$env_dir/share/ggd/Homo_sapiens/hg38/hg38-self-chain-high-identity-ucsc-v1/1
fi


PKG_DIR=`find "$CONDA_SOURCE_PREFIX/pkgs/" -name "$PKG_NAME-$PKG_VERSION*" | grep -v ".tar.bz2" |  grep "$PKG_VERSION.*$PKG_BUILDNUM$"`


if [ -d $RECIPE_DIR ]; then
    rm -r $RECIPE_DIR
fi

mkdir -p $RECIPE_DIR

(cd $RECIPE_DIR && bash $PKG_DIR/info/recipe/recipe.sh)

cd $RECIPE_DIR

## Iterate over new files and replace file name with data package name and data version  
for f in *; do
    ext="${f#*.}"
    filename="{f%%.*}"
    if [[ ! -f "hg38-self-chain-high-identity-ucsc-v1.$ext" ]]  
    then
        (mv $f "hg38-self-chain-high-identity-ucsc-v1.$ext")
    fi  
done

## Add environment variables 
#### File
if [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 1 ]] ## If only one file
then
    recipe_env_file_name="ggd_hg38-self-chain-high-identity-ucsc-v1_file"
    recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
    file_path="$(find $RECIPE_DIR -type f -maxdepth 1)"

elif [[ `find $RECIPE_DIR -type f -maxdepth 1 | wc -l | sed 's/ //g'` == 2 ]] ## If two files
then
    indexed_file=`find $RECIPE_DIR -type f \( -name "*.tbi" -or -name "*.fai" -or -name "*.bai" -or -name "*.crai" -or -name "*.gzi" \) -maxdepth 1`
    if [[ ! -z "$indexed_file" ]] ## If index file exists
    then
        recipe_env_file_name="ggd_hg38-self-chain-high-identity-ucsc-v1_file"
        recipe_env_file_name="$(echo "$recipe_env_file_name" | sed 's/-/_/g' | sed 's/\./_/g')"
        file_path="$(echo $indexed_file | sed 's/\.[^.]*$//')" ## remove index extension
    fi
fi 

#### Dir
recipe_env_dir_name="ggd_hg38-self-chain-high-identity-ucsc-v1_dir"
recipe_env_dir_name="$(echo "$recipe_env_dir_name" | sed 's/-/_/g' | sed 's/\./_/g')"

activate_dir="$env_dir/etc/conda/activate.d"
deactivate_dir="$env_dir/etc/conda/deactivate.d"

mkdir -p $activate_dir
mkdir -p $deactivate_dir

echo "export $recipe_env_dir_name=$RECIPE_DIR" >> $activate_dir/env_vars.sh
echo "unset $recipe_env_dir_name">> $deactivate_dir/env_vars.sh

#### File
    ## If the file env variable exists, set the env file var
if [[ ! -z "${recipe_env_file_name:-}" ]] 
then
    echo "export $recipe_env_file_name=$file_path" >> $activate_dir/env_vars.sh
    echo "unset $recipe_env_file_name">> $deactivate_dir/env_vars.sh
fi
    

echo 'Recipe successfully built!'
