from __future__ import print_function

import argparse
import datetime
import gzip
import io
import json
import os
import sys
from collections import defaultdict


# ---------------------------------------------------------------------------------------------------------------------------------
## Argument Parser
# ---------------------------------------------------------------------------------------------------------------------------------
def arguments():
    """Argument method  """

    p = argparse.ArgumentParser(
        description="Parse GEO file header and update recipe meta-data"
    )

    req = p.add_argument_group("Required Arguments")

    req.add_argument(
        "--geo-acc",
        metavar="GEO Accession ID",
        required=True,
        help="The GEO accession ID",
    )

    req.add_argument(
        "--geo-file", metavar="GEO file", required=True, help="The GEO file to parse"
    )

    req.add_argument(
        "--geo-url",
        metavar="GEO Accession URL",
        required=True,
        help="The GEO Accession ID specific home page URL",
    )

    req.add_argument(
        "--geo-prefix",
        metavar="GEO Accession prefix",
        required=True,
        choices=["GDS", "GPL", "GSM", "GSE"],
        help="The GEO Accession id Prefix. (GDS, GPL, GSM, GSE)",
    )

    req.add_argument(
        "--geo-files-dir",
        metavar="GEO downloaded files",
        required=True,
        help="The directory path to where the files were downloaded",
    )

    req.add_argument(
        "--json-out",
        metavar="JSON out file",
        required=True,
        help="The name of the json output file to create that will contain the ggd meta-recipe environment variables",
    )

    return p.parse_args()


# ---------------------------------------------------------------------------------------------------------------------------------
## Main
# ---------------------------------------------------------------------------------------------------------------------------------


def main():

    args = arguments()

    ## Open GEO File
    try:
        fh = (
            gzip.open(args.geo_file, "rt", encoding="utf-8", errors="ignore")
            if args.geo_file.endswith(".gz")
            else io.open(args.geo_file, "rt", encoding="utf-8", errors="ignore")
        )
    except IOError as e:
        print("\n!!ERROR!! Unable to read the GEO File: '{}'".format(args.geo_file))
        print(str(e))
        sys.exit(1)

    print("\nParsing GEO header for file: {}".format(args.geo_file))

    metadata_dict = defaultdict(list)

    for i, line in enumerate(fh):

        line = line.strip()

        if not line:
            continue

        ## Check if line is a header
        if line[0] == "!":

            line_list = line.strip().split("=")

            if len(line_list) > 1:
                metadata_dict[line_list[0].replace(" ", "")].append(
                    line_list[1].strip()
                )

    fh.close()

    geo_key = (
        "dataset"
        if args.geo_prefix == "GDS"
        else "Platform"
        if args.geo_prefix == "GPL"
        else "Sample"
        if args.geo_prefix == "GSM"
        else "Series"
        if args.geo_prefix == "GSE"
        else None
    )

    title = ", ".join(metadata_dict["!{}_title".format(geo_key)])

    summary = ", ".join(metadata_dict["!{}_summary".format(geo_key)])

    description = ", ".join(metadata_dict["!{}_description".format(geo_key)])

    etype = ", ".join(metadata_dict["!{}_type".format(geo_key)])

    status = ", ".join(metadata_dict["!{}_status".format(geo_key)])

    submission_date = ", ".join(metadata_dict["!{}_submission_date".format(geo_key)])

    last_update_date = ", ".join(metadata_dict["!{}_last_update_date".format(geo_key)])

    organism = set(
        [", ".join(list(set(y))) for x, y in metadata_dict.items() if "organism" in x]
    )

    pubmed_id = set(
        [", ".join(list(set(y))) for x, y in metadata_dict.items() if "pubmed_id" in x]
    )

    link = ", ".join(metadata_dict["!{}_web_link".format(geo_key)])

    ## Set summary environment variable
    env_vars = defaultdict(str)

    ## UPDATE META RECIPE SUMMARY
    new_summary = (
        "GEO Accession ID: {}. Title: {}. GEO Accession site url: {} (See the url for additional information about {}). ".format(
            args.geo_acc, title, args.geo_url, args.geo_acc
        )
        + "Summary: "
        + summary
        + description
    )
    if etype:
        new_summary += " Type: {}".format(etype)

    env_vars["GGD_METARECIPE_SUMMARY"] = new_summary

    ## Update META RECIPE VERSION
    date_string = "Submission date: {}. Status: {}. Last Update Date: {}. Download Date: {}".format(
        submission_date,
        status,
        last_update_date,
        datetime.datetime.now().strftime("%m-%d-%Y"),
    )
    env_vars["GGD_METARECIPE_VERSION"] = date_string

    ## Update META RECIPE Keywords
    keywords = [
        args.geo_acc,
        args.geo_url,
        etype,
        "PubMed id: {}".format(", ".join(sorted(list(pubmed_id)))) if pubmed_id else "",
        "WEB LINK: {}".format(link) if link else "",
    ]
    env_vars["GGD_METARECIPE_KEYWORDS"] = ", ".join(keywords)

    ## Update META RECIPE SPECIES
    env_vars["GGD_METARECIPE_SPECIES"] = ", ".join(sorted(list(organism)))

    print("\nCreating environment variable json file: {}".format(args.json_out))
    json.dump(dict(env_vars), open(args.json_out, "w"))


if __name__ == "__main__":
    sys.exit(main() or 0)
