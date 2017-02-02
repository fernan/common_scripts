#!/bin/bash

module load star
FASTA="$1"
DB=$(pwd)
mkdir -p ${DB}/${FASTA%.*}

STAR \
  --runMode genomeGenerate \
  --runThreadN 16 \
  --genomeDir ${DB}/${FASTA%.*}
  --genomeFastaFiles ${FASTA}
