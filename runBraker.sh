#!/bin/bash
# needs rnaseq reads as well as the genome to be annotated
# if you have multiple RNA seq libraries merge them together (all R1's and all R2's seperately)
module load hisat2
module load braker

R1="$1"
R2="$2"
GENOME="$3"
BASE=$(basename ${GENOME%.*})

hisat2-build ${GENOME} ${GENOME%.*}
hisat2 -p 31 -x ${GENOME%.*} -1 ${R1} -2 ${R2} | samtools view -bS - > ${BASE}_rnaseq.bam
samtools sort ${BASE}_rnaseq.bam ${BASE}_sorted_rnaseq
braker.pl --cores=32 --overwrite --species=${BASE} --genome=${GENOME} --bam=${BASE}_sorted_rnaseq.bam
