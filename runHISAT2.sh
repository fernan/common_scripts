#!/bin/bash

module load hisat2
module load samtools

p=31 # number of thereads to use (specify one less from total available for sam2bam conversion)
DATABASE="$3"
R1_FQ="$1"
R2_FQ="$2"

OUTPUT=$(basename ${R1_FQ} |cut -f 1 -d "_");

hisat2 \
  -p 16 \
  -x ${DATABASE} \
  -1 ${R1_FQ} \
  -2 ${R2_FQ} | \
samtools view -bS - > \
   ${OUTPUT}.bam

samtools sort ${OUTPUT}.bam ${OUTPUT}_sorted
