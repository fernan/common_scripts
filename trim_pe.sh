#!/bin/bash
module use /shared/software/GIF/modules
module load trimmomatic
pwd=$(pwd)
input1=$1
input2=$2
output1=$(basename ${input1} | sed 's/.fastq.gz$//g')
output2=$(basename ${input2} | sed 's/.fastq.gz$//g')
java -jar ${TRIMMOMATIC_HOME}/trimmomatic-0.36.jar PE \
    -phred33 \
    -threads 16 ${input1} ${input2} ${output1}_paired.fq.gz ${output1}_unpaired.fq.gz ${output2}_paired.fq.gz ${output2}_unpaired.fq.gz \
     ILLUMINACLIP:${progdir}/adapters/TruSeq3-PE.fa:2:30:10 \
     LEADING:3 \
     TRAILING:3 \
     SLIDINGWINDOW:4:15 \
     MINLEN:36
