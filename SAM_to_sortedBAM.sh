#!/bin/bash
#convert sam to sorted bam file using samtools
# specify the sam file as first argument
module load samtools

SAM="$1"
samtools view --threads 16 -b -o ${SAM%.*}.bam ${SAM}
samtools sort -o ${SAM%.*}_sorted.bam -T ${SAM%.*}_temp --threads 16 ${SAM%.*}.bam
