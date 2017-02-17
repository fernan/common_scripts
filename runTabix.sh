#!/bin/bash
# This just sorts, checks for deficiencies, bgzips, and indexes with tabix
# usage: sh run_JBupload.sh <your_gff>
module use /work/GIF/software/modules
module load genometools/1.5.9
module load tabix/0.2.6


GFF="$1"

sort -k1,1 -k 4,4n $GFF |grep -v "###" |grep -v "======" |grep -v "#" >${GFF%.*}_sorted.gff
#this checks your format for correctness
gt gff3 -sortlines -tidy ${GFF%.*}_sorted.gff > ${GFF%.*}_sorted_formatted.gff
bgzip  ${GFF%.*}_sorted_formatted.gff
tabix -p gff  ${GFF%.*}_sorted_formatted.gff.gz
