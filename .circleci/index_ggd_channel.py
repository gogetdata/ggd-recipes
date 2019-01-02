#------------------------------------------------------------------------------------------------------------
## Import Statment 
#------------------------------------------------------------------------------------------------------------
from __future__ import print_function
import sys 
import os 
import re
import argparse
import requests
import bs4
from bs4 import BeautifulSoup
import subprocess as sp
from git import Repo
import shutil

## SSH url for ggd-metadata url
METADATA_GITHUB_URL = "git@github.com:gogetdata/ggd-metadata.git"
#------------------------------------------------------------------------------------------------------------
## Argument Parser
#------------------------------------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Upload ggd packages to an aws s3 bucket")
parser.add_argument("-c", "--conda_channel", default="genomics", help="The anaconda channel to download (Default = genomics)")
parser.add_argument("-t", "--tmp_dir", required=True, help="The temporary directory to store the ggd metadata repo in")

args = parser.parse_args()


#------------------------------------------------------------------------------------------------------------
## Methods/Functions
#------------------------------------------------------------------------------------------------------------

# get_pkg_name
# ===========
# Method used to get the pkg names from an anaconda.com url. 
#  This method uses requests to send a request to the url and open
#  read the html file. BeautifulSoup4 is used to parse the html file
# 
# Parameters:
# ----------
# 1) header: An http request header. Must be a dictionary and have the "User-Agent" key. 
#            the default "user-Agent" that package provideds cannot access the secured https 
#            url. The "User-Agent" must be changed to a Chrome, Firefox, etc. agent.
# 2) conda_channel: The anaconda channel to download pkg_names from
# 3) page_num: The page number in the conda channel to get info from 
# Returns:
# 1) A list of pkg names from the conda channel repo page
def get_pkg_names(header, conda_channel, page_num):
    pkg_list = []
    req = requests.get("https://anaconda.org/{channel}/repo?page={pagenum}".format(channel=conda_channel,pagenum=page_num), header)
    html = req.content
    soup = BeautifulSoup(html, "html.parser")
    for pkg_str in soup.find_all("span", class_="packageName"):
        pkg_str = str(pkg_str)
        pkg_list.append(pkg_str[pkg_str.find(">")+1:pkg_str.find("</span")])
    return(pkg_list)


# get_pkg_files
# =============
# Method used to collect a pkg's .tar.bz2 files for a specific pkg in a specific channel on the anaconda cloud.
#  The files are returned in a list, where each file is represnted as a tuple in the list.
#  The tuple indecies = [0] The files anaconda url, [1] The path on the conda cloud where the file is stored,
#  [2] The .tar.bz2 file name, [3] The file platform (example = linux-64, noarch, osx-64, etc)
# A list of tuples will be returned 
# 
# Parameters:
# ----------
# 1) header: An http request header. Must be a dictionary and have the "User-Agent" key. 
#            the default "user-Agent" that package provideds cannot access the secured https 
#            url. The "User-Agent" must be changed to a Chrome, Firefox, etc. agent.
# 2) conda_channel: The anaconda channel to download pkg_names from
# 3) pkg_name: The name of the pkg to get the files for.
# 4) page_num: The page number in the conda channel to get info from 
# Returns:
# A list of tuples, where each tuple holds info about a file
def get_pkg_files(header, conda_channel, pkg_name, page_num):
    pkg_file_list = [] # List of tuples: tuple = ([0] = anaconda url, [1] = anaconda_path, [2] = tar.bz2 file name [3] = platform)
    req = requests.get("https://anaconda.org/{channel}/{pkgname}/files?page={pagenum}".format(channel=conda_channel,pkgname=pkg_name,pagenum=page_num), header)
    html = req.content
    soup = BeautifulSoup(html, "html.parser")
    for url in soup.find_all("a", string=re.compile("\.tar\.bz2")):
        url = str(url)
        anaconda_path = eval(url[url.find("=")+1:url.find(">")])
        tarfile = anaconda_path.split("/")[-1]
        platform = anaconda_path.split("/")[-2]
        anaconda_url = "https://anaconda.org{path}".format(path=anaconda_path)
        pkg_file_list.append((anaconda_url, anaconda_path, tarfile, platform))
    return(pkg_file_list)


# make_empty_repodata
# ==================
# Method used to create three empty repodata files: repodata.json, repodata.json.bz2, and 
#  repodata2.json
# 
# Parameters:
# -----------
# 1) path: The file path to save the empty repodata files to
def make_empty_repodata(path):
    with open(os.path.join(path,"repodata.json"), "w") as rd:
        rd.write("{}")
    with open(os.path.join(path,"/repodata.json.bz2"), "w") as rdbz2:
        rdbz2.write("{}")
    with open(os.path.join(path,"/repodata2.json"), "w") as rd2:
        rd2.write("{}")


# download_with_request
# ====================
# Method used download a .tar.bz2 file from the anaconda cloud using the "requests" moduel
#  This method replaces a previous model which used python-wget. The python-wget method 
#  provided corupt files that couldn't be indexed. 
# 
# Parameters:
# -----------
# 1) file_url: the url that hosts the file on the anaconda cloud
# 2) download_path: The file path to download the file to
# 3) file_name: The name of the file to download
def download_with_request(file_url, download_path, file_name):
    response = requests.get(file_url)
    tarfile = open(os.path.join(download_path, file_name), "wb")
    tarfile.write(response.content)
    tarfile.close()


# get_pkg_file_names
# ==================
# !!!!Not fully implemented. (Not working)!!!!
#  Method used to get the pkg and file names for the anaconda.org/<channel>/repo/files url
def get_pkg_file_names(header, conda_channel, page_num):
    req = requests.get("https://anaconda.org/{channel}/repo/files?page={pagenum}".format(channel=conda_channel,pagenum=page_num), header)
    html = req.content
    soup = BeautifulSoup(html, "html.parser")
    file_str_list = [file_str for file_str in soup.find_all("label", class_="inline fileLabel")]
    return(file_str_list)
        
    

#------------------------------------------------------------------------------------------------------------
## Main Block
#------------------------------------------------------------------------------------------------------------
## Get the name of the pkgs in ggd-{channel}
## The User-Agent header for web "get" request 
conda_channel = "ggd-"+args.conda_channel
headers = {"User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.146 Safari/537.36"}
end = False 
page = 0
previous_list = [] # A list that holds the previous page's pkg names
pkg_name_list = [] # A dynamic list containing the pkg names in an anaconda channel
print("\n-> Gathering package name information for the %s anaconda channel\n" %(conda_channel))
while end == False:
    page += 1
    new_pkg_list = get_pkg_names(headers, conda_channel, page)
    if new_pkg_list == previous_list: ## If no change from prevcious page, stop
        break
    elif page > 1000000:
        print("Too many pages to look at!!")
        sys.exit(1)
    else:
        pkg_name_list.extend(new_pkg_list)
        previous_list = new_pkg_list


## Get the file names and urls for each pkg in the ggd-<channel>
pkg_file_list = [] ## List of tuples, where eacht tuple containes info about a pkg_file. # each  tuple = ([0] = anaconda url, [1] = anaconda_path, [2] = tar.bz2 file name [3] = platform) 
for pkg in pkg_name_list:
    page = 0
    previous_pkg_files = []
    print("-> Finding files for %s in the %s anaconda channel" %(pkg,conda_channel))
    while end == False:
        page += 1
        new_pkg_file_list = get_pkg_files(headers, conda_channel, pkg, page)
        if new_pkg_file_list == previous_pkg_files: ## If no change from previous page, stop
            break
        else:
            pkg_file_list.extend(new_pkg_file_list)
            previous_pkg_files = new_pkg_file_list

## Make a temp build dir to store the downloaded files 
cwd = os.getcwd()
tmp_build_dir = os.path.join(cwd,"anaconda-tmp/{channel}-bld/".format(channel=conda_channel))
print("\n-> Making a tmp directory to store pkg files: %s\n" %tmp_build_dir)
if not os.path.exists(tmp_build_dir):
    os.makedirs(tmp_build_dir)

## Downlaod each file to the temp build dir
download_count = 0
for file_tuple in pkg_file_list:
    file_url = file_tuple[0]
    anaconda_path = file_tuple[1]
    tar_file = file_tuple[2]
    platform = file_tuple[3]
    local_download_path = os.path.join(tmp_build_dir,platform)
    if not os.path.isdir(local_download_path):
        os.makedirs(local_download_path)
    print("-> Downloading: %s\n\tIn: %s" %(tar_file, local_download_path))
    download_with_request(file_url, local_download_path, tar_file)
    download_count += 1

print("\n-> Downloaded {filenum} files from https://anaconda.org/{channel}".format(filenum = download_count,channel=conda_channel))

## Index the .tar.bz2 files downloaded to the temp build dir using conda index
print("\n-> Indexing .tar.bz2 files in order to create the 'channeldata.json' metadata file\n")
sp.check_call(['conda', 'index', tmp_build_dir, '-n',  conda_channel])
print("\n\n-> The channeldata.json file is located at: %s" %tmp_build_dir) 

## Move metadata files to ggd-recipes/channeldata/
print("\n-> Add updated metadata to the ggd-metadata repo")
tmp_repo_dir = os.path.join(args.tmp_dir, "ggd-metadata")
if not os.path.isdir(tmp_repo_dir):
	os.makedirs(tmp_repo_dir)
Repo.clone_from(METADATA_GITHUB_URL,tmp_repo_dir) 
os.chdir(tmp_repo_dir)
Repo(tmp_repo_dir).remotes.origin.pull()
repo = Repo(tmp_repo_dir)
channeldata_file = os.path.join(tmp_build_dir, "channeldata.json")
index_file = os.path.join(tmp_build_dir, "index.html")
rss_file = os.path.join(tmp_build_dir, "rss.xml")
destination = os.path.join(tmp_repo_dir, "channeldata", args.conda_channel)
shutil.copy(channeldata_file,destination)
shutil.copy(index_file,destination)
shutil.copy(rss_file,destination)

## Add, commit, and push to ggd-metadata repo
sp.check_call(["git", "config", "user.email", "CIRCLECI@circleci.com"])
sp.check_call(["git", "config", "user.name", "CIRCLECI"])
repo.git.add("channeldata/"+args.conda_channel+"/channeldata.json")
repo.git.add("channeldata/"+args.conda_channel+"/index.html")
repo.git.add("channeldata/"+args.conda_channel+"/rss.xml")
from datetime import datetime
date_time = datetime.today().isoformat()
repo.git.commit("-m", "New conda index for the ggd-{channel} channel. ({date})".format(channel=args.conda_channel, date=date_time))
repo.git.push()

print("\n-> Successfully pushed new channeldata.json file to the ggd-metadata repo")
