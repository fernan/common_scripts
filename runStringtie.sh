#!/bin/bash

module load stringtie

#Stringtie generates FPKM, read coverage, and TPM based on RNA-seq mapping to a genome/transcriptome. 
#Bam file must be sorted by chromosome and position, typically sort -k1,1V -k4,5nr
#-B creates a ballgown output file that can be used to generate RNA-seq statistics, but the file is autonamed.  Beware, if multiple bams are ran in the same folder, this file will be overwritten.
#-e uses only the gff supplied to generate the stats, which is useful if you dont want to have stringtie perform a de-novo assembly of possible missing genes. 
#sh runStringtie.sh SOMETHINGSOMETHING_SORTED.BAM

BAMFILE=$1
SortedGFF3=$2

stringtie ${BAMFILE} -p 16 -G ${SortedGFF3} -e -B -A ${BAMFILE%.*}_GeneAbundance.tab >${BAMFILE%.*}_GeneAbundance.gtf

