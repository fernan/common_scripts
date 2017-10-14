#!/bin/bash
if [ $# -lt 1 ] ; then
        echo ""
        echo "usage: downloadSRA_ebi.sh <FILE> "
        echo ""
        echo "FILE should contain list of SRR ids, one per line"
        echo "downloads the SRR file from the ebi server"
        echo "considers if the file is single-end or paired-end and downloads"
        echo ""
exit 0
fi

function validate_url(){
  if [[ $(wget -S --spider $1  2>&1 | grep 'No such file') ]]; then echo "false"; fi
}

file="$1"
while read line; do
num=$(echo "${line: -1}")
part=$(echo "${line::6}")

if [[ $(validate_url ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${part}/00${num}/${line}/${line}.fastq.gz) -eq false ]]; then
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${part}/00${num}/${line}/${line}_1.fastq.gz
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${part}/00${num}/${line}/${line}_2.fastq.gz
else
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${part}/00${num}/${line}/${line}.fastq.gz
fi
done<$file
