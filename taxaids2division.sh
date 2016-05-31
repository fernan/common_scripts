#!/bin/bash

# converts taxa ids to various "divisions" classified by NCBI
# uses NCBI e-uitls which feteches directly from the NCBI server
# run it as taxaids2division.sh taxaids

TAXAIDS="$1"

if [ $# -lt 1 ] ; then
        echo "needs taxa id file to run"
        echo "run this script as: taxaids2division.sh taxaids"
        exit 0
fi


while read line; do
g=$(curl http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi\?db\=taxonomy\&id="${line}"\&retmode=xml | grep "Division" | cut -f 2 -d ">" | cut -f 1 -d "<");
echo -e "$line\t$g";
done<"${TAXAIDS}" 2> /dev/null
