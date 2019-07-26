from __future__ import print_function
import os
import argparse
from git import Repo
import shutil
import json
import subprocess as sp


#------------------------------------------------------------------------------------------------
# Argument Parser
#------------------------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Get the species and associated genome builds available in ggd")
parser.add_argument("-rp", "--repo_path", help="The file path to the ggd-recipe repo")
parser.add_argument("-t", "--tmp_dir", required=True, help="The temporary directory to store the ggd metadata repo in")

args = parser.parse_args()


#------------------------------------------------------------------------------------------------
# File paths
#------------------------------------------------------------------------------------------------
GENOME_DIR = os.path.join(args.repo_path,"genomes")
METADATA_GITHUB_URL = "git@github.com:gogetdata/ggd-metadata.git"


#------------------------------------------------------------------------------------------------
# Methods/Functions
#------------------------------------------------------------------------------------------------

def get_builds(species):
    """Get the genome_builds for a specific species

    get_builds
    ==========
    This method is used to get the genome builds associated with a specific species available in the ggd-recipes repo. 
    
    Parameters:
    -----------
    1) species: The species in which to get the available genome builds for

    Returns:
    1) A list of available genome builds for the specified species
    """

    ## Get the species directory 
    species_dir = os.path.join(GENOME_DIR,species)

    ## Make sure the directory exists
    assert os.path.isdir(species_dir)

    ## Get all available genome builds for that species
    return(os.listdir(species_dir))


#------------------------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------------------------

## Get unique species set
species_set = set(os.listdir(GENOME_DIR))

## Get genome builds for each species
species_dict = dict() ## Dictionary with key = species, value = list of genome builds
build_dict = dict() ## Dictionary with key = genome_build, value = species
for s in species_set:
    genome_builds = get_builds(s)
    species_dict[s] = genome_builds
    for b in genome_builds:
        build_dict[b] = s

## Write json output
tmp_dir = os.path.join(os.getcwd(),"species_and_genome_build/")
print("\n-> Making a tmp directory to store species and genome build json files: %s" %tmp_dir)
if not os.path.exists(tmp_dir):
    os.makedirs(tmp_dir)

print("\n\t-> Writing species_to_build.json")
species_file_path = os.path.join(tmp_dir,"species_to_build.json")  
with open(species_file_path, "w") as sf:
    json.dump(species_dict,sf)

print("\n\t-> Writing build_to_species.json")
build_file_path = os.path.join(tmp_dir,"build_to_species.json") 
with open(build_file_path, "w") as gf:
    json.dump(build_dict,gf)

## Get current working dir
cwd = os.getcwd()

## Make metadata_repo_dir
metadata_repo_dir = os.path.join(args.tmp_dir,"ggd-metadata")
if not os.path.isdir(metadata_repo_dir):
    os.makedirs(metadata_repo_dir)

Repo.clone_from(METADATA_GITHUB_URL,metadata_repo_dir)
os.chdir(metadata_repo_dir)
Repo(metadata_repo_dir).remotes.origin.pull()
repo = Repo(metadata_repo_dir)

## Check if species and builds are different 
species_json_dict = {}
with open(os.path.join(metadata_repo_dir,"species_and_build","species_to_build.json"), "r") as sj:
    species_json_dict = json.load(sj)

build_json_dict = {}
with open(os.path.join(metadata_repo_dir,"species_and_build","build_to_species.json"), "r") as bj:
    build_json_dict = json.load(bj)

dest = os.path.join(metadata_repo_dir,"species_and_build")

### Add, commit, and push to ggd-metadata repo
sp.check_call(["git", "config", "user.email", "CIRCLECI@circleci.com"])
sp.check_call(["git", "config", "user.name", "CIRCLECI"])

commit = False
if sorted(species_json_dict.keys()) != sorted(species_dict.keys()):
    shutil.copy(species_file_path, dest)
    repo.git.add("species_and_build/species_to_build.json")
    commit = True
    print("\n-> Add an updated species json file to ggd-metadata")

else:
    print("\n-> No change in species. The species json file will remain the same") 

if sorted(build_json_dict.keys()) != sorted(build_dict.keys()):
    shutil.copy(build_file_path, dest)
    repo.git.add("species_and_build/build_to_species.json")
    commit = True
    print("\n-> Add an updated geonme build json file to ggd-metadata")

else:
    print("\n-> No change in genome builds. The build json file will remain the same") 

if commit:
    from datetime import datetime
    date_time = datetime.today().isoformat()
    repo.git.commit("-m", "Update species_to_build.json and build_to_species.json files. ({date})".format(date=date_time))
    repo.git.push()
    print("\n-> Successfuly pushed new species and/or build json file(s) to ggd-metadata repo")

## Retrun to cwd
os.chdir(cwd)


