#!/bin/sh
set -eo pipefail -o nounset


genome=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/GRCh38/GRCh38.genome
## Get the .genome  file
genome2=https://raw.githubusercontent.com/gogetdata/ggd-recipes/master/genomes/Homo_sapiens/hg38/hg38.genome
## Get the chromomsome mapping file
chr_mapping=$(ggd get-files hg38-chrom-mapping-ensembl2ucsc-ncbi-v1 --pattern "*.txt")

grch38_gtf="$(ggd get-files grch38-gene-features-ensembl-v1 -p 'grch38-gene-features-ensembl-v1.gtf.gz')"

## Cancer genes
cat <<EOF > cancer_genes.tsv
ABL1
ABL2
AF15Q14
AF1Q
NCKIPSD
AFF4
AKT2
ALK
ALO17
APC
ARHGEF12
ARHH
ARNT
ASPSCR1
ATF1
ATIC
ATM
BCL10
BCL11A
BCL11B
BCL2
BCL3
BCL5
BCL6
BCL7A
BCL9
BCR
BHD
BIRC
BLM
BMPR1A
BRAF
BRCA1
BRCA2
BRD4
BTG1
CBFA2T1
CBFA2T3
CBFB
CBL
CCND1
CDH1
CDK4
CDKN2A
CDKN2A
CDX2
CEBPA
CEP1
CHIC2
CHN1
CLTC
COL1A1
COPEB
COX6C
CREBBP
CTNNB1
CYLD
D10S170
DDB2
DDIT3
DDX10
DEK
EGFR
EIF4A2
ELKS
ELL
EP300
EPS15
ERBB2
ERCC2
ERCC3
ERCC4
ERCC5
ERG
ETV1
ETV4
ETV6
EVI1
EWSR1
EXT1
EXT2
FACL6
FANCA
FANCC
FANCD2
FANCE
FANCF
FANCG
FEV
FGFR1
FGFR1OP
FGFR2
FGFR3
FH
FIP1L1
FLI1
FLT3
FLT4
FNBP1
FOXO1A
FOXO3A
FSTL3
FUS
GAS7
GATA1
GMPS
GNAS
GOLGA5
GPC3
GPHN
GRAF
HEI10
HIP1
HIST1H4I
HLF
HMGA2
HOXA11
HOXA13
HOXA9
HOXC13
HOXD11
HOXD13
HRAS
HRPT2
HSPCA
HSPCB
IGH
IGK
IGL
IL21R
IRF4
IRTA1
JAK2
KIT
KRAS2
LAF4
LASP1
LCK
LCP1
LCX
LHFP
LMO1
LMO2
LPP
LYL1
MADH4
MALT1
MAML2
MAP2K4
MDS1
MECT1
MEN1
MET
MHC2TA
MLF1
MLH1
MLL
MLLT1
MLLT10
MLLT2
MLLT3
MLLT4
MLLT6
MLLT7
MN1
MSF
MSH2
MSH6
MSN
MUTYH
MYC
MYCL1
MYCN
MYH11
MYH9
MYST4
NACA
NBS1
NCOA2
NCOA4
NF1
NF2
NOTCH1
NPM1
NR4A3
NRAS
NSD1
NTRK1
NTRK3
NUMA1
NUP214
NUP98
NUT
OLIG2
PAX3
PAX5
PAX7
PAX8
PBX1
PCM1
PDGFB
PDGFRA
PDGFRB
PICALM
PIM1
PML
PMS1
PMS2
PMX1
PNUTL1
POU2AF1
PPARG
PRCC
PRKAR1A
PRO1073
PSIP2
PTCH
PTEN
PTPN11
RAB5EP
RAD51L1
RAP1GDS1
RARA
RB1
RECQL4
REL
RET
RPL22
RUNX1
RUNXBP2
SBDS
SDHB
SDHC
SDHD
SEPT6
SET
SFPQ
SH3GL1
SMARCB1
SMO
SS18
SS18L1
SSH3BP1
SSX1
SSX2
SSX4
STK11
STL
SUFU
TAF15
TAL1
TAL2
TCF1
TCF12
TCF3
TCL1A
TEC
TFE3
TFEB
TFG
TFPT
TFRC
TIF1
TLX1
TLX3
TNFRSF6
TOP1
TP53
TPM3
TPM4
TPR
TRA
TRB
TRD
TRIM33
TRIP11
TSC1
TSC2
TSHR
VHL
WAS
WHSC1L1
WRN
WT1
XPA
XPC
ZNF145
ZNF198
ZNF278
ZNF384
ZNFN1A1
EOF


cat << EOF > parse_gtf_by_gene.py

"""
Get a list of genome coordinates for a list of cancer genes
"""
import sys 
import io
import gzip
gtf_file = sys.argv[1] ## A gtf file with CDS features
cancer_gene_file = sys.argv[2] ## A single column tsv file for cancer genes
outfile = sys.argv[3] ## File to write to
## Get a set of gene symbols
cancer_gene_set = {}
with io.open(cancer_gene_file, "rt", encoding = "utf-8") as cancer:
    cancer_gene_set = set(x.strip() for x in cancer)
    
## Parse the gtf file
fh = gzip.open(gtf_file, "rt", encoding = "utf-8") if gtf_file.endswith(".gz") else io.open(gtf_file, "rt", encoding = "utf-8")
cancer_gene_dict = dict()
header = []
for line in fh:
    if line[0] == "#":
        header = line.strip().split("\t")
        continue
    line_dict = dict(zip(header,line.strip().split("\t")))
    line_dict.update({x.strip().replace("\"","").split(" ")[0]:x.strip().replace("\"","").split(" ")[1] for x in line_dict["attribute"].strip().split(";")[:-1]})
    ## If the current gene is in the cancer gene set
    if line_dict["gene_name"] in cancer_gene_set:
        
        if line_dict["gene_name"] not in cancer_gene_dict:
            cancer_gene_dict[line_dict["gene_name"]] = [] 
        ## If CDS or stop_codon feature, cancerd feature info to cancer_gene_dict
        if line_dict["feature"] == "CDS" or line_dict["feature"] == "stop_codon":
            ## Change 1 based start to zero based start
            cancer_gene_dict[line_dict["gene_name"]].append([str(line_dict["#chrom"]), 
                                                         str(int(line_dict["start"]) - 1),  
                                                         str(line_dict["end"]), 
                                                         str(line_dict["strand"]), 
                                                         str(line_dict["gene_id"]), 
                                                         str(line_dict["gene_name"]),
                                                         str(line_dict["transcript_id"]),
                                                         str(line_dict["gene_biotype"])
                                                        ])
fh.close()
## Write dict out
with open(outfile, "w") as o:
    for gene, coor in cancer_gene_dict.items():
        for line in coor:
            o.write("\t".join(line) + "\n")
EOF


python parse_gtf_by_gene.py $grch38_gtf cancer_genes.tsv unflattened_cancer_genes.bed  


cat << EOF > sort_columns.py
"""
sort the transcript id column
sort and get a unique list of the gene column
""" 
import sys
for line in sys.stdin.readlines():
    line_list = line.strip().split("\t")
    ## Sort column 4 - 8 and get a uniqe list
    line_list[3] = ",".join(sorted(list(set(line_list[3].strip().split(",")))))
    line_list[4] = ",".join(sorted(list(set(line_list[4].strip().split(",")))))
    line_list[5] = ",".join(sorted(list(set(line_list[5].strip().split(",")))))
    line_list[6] = ",".join(sorted(list(set(line_list[6].strip().split(",")))))
    line_list[7] = ",".join(sorted(list(set(line_list[7].strip().split(",")))))
    ## Print to stdout
    print("\t".join(line_list))
EOF

## Merge and sort cancer genes with coordinates
gsort unflattened_cancer_genes.bed $genome \
    | bedtools merge -i - -c 4,5,6,7,8 -o collapse \
    | awk -v OFS="\t" 'BEGIN { print "#chrom\tstart\tend\tstrand\tgene_ids\tgene_symbols\ttranscript_ids\tgene_biotypes" } {print $0}' \
    | python sort_columns.py \
    | gsort --chromosomemappings $chr_mapping /dev/stdin $genome2 \
    | bgzip -c > hg38-cancer-genes-futreal-v1.bed.gz 
tabix hg38-cancer-genes-futreal-v1.bed.gz 

wget --quiet $genome2

## Get ad gene complement coordinates 
sed "1d" hg38.genome \
    | bedtools complement -i <(zgrep -v "#" hg38-cancer-genes-futreal-v1.bed.gz) -g /dev/stdin \
    | gsort /dev/stdin $genome2 \
    | awk -v OFS="\t" 'BEGIN {print "#chrom\tstart\tend"} {print $1,$2,$3}' \
    | bgzip -c > hg38-cancer-genes-futreal-v1.compliment.bed.gz 
tabix hg38-cancer-genes-futreal-v1.compliment.bed.gz 


rm hg38.genome
rm cancer_genes.tsv
rm unflattened_cancer_genes.bed
rm parse_gtf_by_gene.py
rm sort_columns.py


