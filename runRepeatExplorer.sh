#!/bin/bash
# Prepares DNA-seq reads for repeat explorer
if [ $# -lt 2 ] ; then
        echo "usage: bash runRepeatExplorer.sh <DNAseq_R1> <DNAseq_R2> <90% read length>"
        echo ""
        echo "To obtain reads to run through repeat explorer, files must be fastq.gz"
        echo ""
exit 0
fi
module load trimmomatic
module load java
module load GIF2/seqtk

R1="$1"
R2="$2"
ReadLength="$3"
head -n 2000000 <(zcat $R1) >200kForward.fastq
head -n 2000000 <(zcat $R2) >200kReverse.fastq

java -jar /opt/rit/app/trimmomatic/0.36/bin/trimmomatic-0.36.jar PE -threads 16 -phred33 -trimlog 200k.log 200kForward.fastq 200kReverse.fastq 200kForward.trimmedpaired.fastq 200kForward.trimmedunpaired.fastq 200kReverse.trimmedpaired.fastq 200kReverse.trimmedunpaired.fastq ILLUMINACLIP:/opt/rit/app/trimmomatic/0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:$ReadLength

awk '/^>/{print ">" ++i"f"; next}{print}' 200kForward.trimmedpaired.fastq >Really200kForward.trimmedpairedRenamed.fasta
awk '/^>/{print ">" ++i"f"; next}{print}' 200kReverse.trimmedpaired.fastq >Really200kReverse.trimmedpairedRenamed.fasta

seqtk mergepe Really200kForward.trimmedpairedRenamed.fasta Really200kReverse.trimmedpairedRenamed.fasta >Really200kReverse.trimmedpairedRenamedInterlaced.fasta
