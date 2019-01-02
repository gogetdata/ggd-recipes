#-------------------------------------------------------------------------------------------------------------
## Import Statements
#-------------------------------------------------------------------------------------------------------------
from __future__ import print_function 
import sys 
import os
import subprocess as sp
import re
import tarfile
import yaml
import argparse


p = argparse.ArgumentParser(description="Get the file paths for a .tar.bz2 ggd package")
p.add_argument("-t", "--tarfile", required=True, help="The .tar.bz2 file")
p.add_argument("-cr", "--conda_root", required=True, help="The conda root (conda info --root)")

args = p.parse_args()


## Get the path to the files created during package processing from the package yaml file in the .tar.bz2 file
with tarfile.open(args.tarfile, "r:bz2") as tarball_file:
	yamlFile = tarball_file.extractfile(tarball_file.getmember("info/recipe/meta.yaml.template"))
	yaml_dict = yaml.load(yamlFile)
	species = yaml_dict["about"]["identifiers"]["species"]
	genome_build = yaml_dict["about"]["identifiers"]["genome-build"] 
	name = yaml_dict["package"]["name"]
	version = yaml_dict["package"]["version"]
	file_path = os.path.join(args.conda_root, "share", "ggd", species, genome_build, name, version)
	print(file_path)

