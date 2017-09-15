## Arabidopsis RNAseq Processing

A list of BioProject along with the metadata was already prepared (Excel sheet from Priyanka, rows 504 to 4225 only). We used this as a starting point for processing. First we had to check if these BioProjects contained paired reads or not. A list of BioProject ids were prepared (one per line) and saved as `rows_504_4225.txt` file

All the SRR numbers contained in the BioProjects were then obtained using `edirect` utility
```
module load edirect
while read line; do \
esearch -db sra -query $line | efetch --format runinfo |cut -d "," -f 1; 
done<rows_504_4225.txt
```
The output was saved as `SRRnumbers.txt`

Next, we checked if the SRR number listed in the file are paired-end or single end format. For this, following script `CheckFASTQ.sh` was set up:

```
#!/bin/bash

if [[ $(fastq-dump -X 1 -Z --split-files $1 2> /dev/null | wc -l) -eq 4 ]]
then
    echo "$1 single-end" >&2
else
    echo "$1 paired-end" >&2
fi
```
and was executed using GNU parallel as follows:

```
module load parallel
parallel --jobs 16 --joblog checkfastq.log --workdir $PWD "./CheckFASTQ.sh {}" ::: SRRnumbers.txt > run_ids.info

grep -v "single-end" run_ids.info > run_ids.info.pe
```

Now, the file run_ids.pe contained only paired end SRR runs.

To prefetch the SRR files, `aspera` grid-ftp was used. The `PrefetchSRA.sh` script was used

```
#!/bin/bash
module load sra-toolkit/2.8.0
module load aspera

prefetch \
   --max-size 100G \
   --transport ascp \
   --ascp-path "/shared/software/GIF/programs/aspera/3.6.2/bin/ascp|/shared/software/GIF/programs/aspera/3.6.2/etc/asperaweb_id_dsa.openssh" \
   $1
```

and was executed as
```
cat run_ids.pe | \
parallel \
   --jobs 16 \
   --joblog prefetch.log  
   "./PrefetchSRA.sh {}"
```

Next, SRA files were converted to FASTQ files

the script `sra2fq.sh` was set up:

```
#!/bin/bash
module load sra-toolkit/2.8.0
NCBI_DIR="/data013/GIF/arnstrm/ncbi_sra_temp/sra"

fastq-dump        \
    --readids          \
    --split-files      \
    --dumpbase         \
    --skip-technical   \
    --clip             \
    --qual-filter-1    \
    --gzip             \
    --outdir /data019/LAS/Wurtele_Lab/20160119_Arabidopsis_RNAseqProcessing/fastq_files \
    $NCBI_DIR/${1}.sra 2>&1 >> fastq.log
```
and was executed as:

```
cat run_ids.pe | parallel --jobs 16 --joblog sra2fq.log  "./sra2fq.sh {}"
```

TAIR10 cds were downloaded:

```
wget https://www.arabidopsis.org/download_files/Sequences/TAIR10_blastsets/TAIR10_cdna_20101214_updated
```

and indexed using `kallisto`

```
module load kallisto
kallisto index -i TAIR10_allCDS TAIR10_cdna_20101214_updated
```
script for quantifying reads `quant_fastq.sh` was setup

```
#!/bin/bash

module purge
module load kallisto

transcriptome="$1"
runid="$2"
mkdir -p $(pwd)/kallisto_A11/${runid}
outdir=$(pwd)/kallisto_A11/${runid}

r1=done_fastq_files/${runid}_1.fastq.gz
r2=done_fastq_files/${runid}_2.fastq.gz
# align reads to transcriptome index
kallisto quant                      \
    --index="$transcriptome"        \
    --bootstrap-samples=100         \
    --output-dir="${outdir}" \
    --threads=16                     \
    $r1 $r2

# move results and run details into results folder
mv $kallisto_outdir/abundance.tsv $outdir/${runid}.tsv
mv $kallisto_outdir/abundance.h5 $outdir/${runid}.h5
mv $kallisto_outdir/run_info.json $outdir/${runid}.json
```
and was executed using a while loop

```
while read line; do \
./quant_fastq.sh TAIR10_allCDS $line
done<run_ids.pe
```
(actually this step was parallelized by submitting across several nodes on a hpc)


The tsv files containing counts and TPM were merged as follows:

joinr.sh *.tsv >> kallisto_out_tair10.txt

the script `joinr.sh`

```
#!/bin/bash

if [[ $# -ge 2 ]]; then
    function __r {
        if [[ $# -gt 1 ]]; then
            exec join - "$1" | __r "${@:2}"
        else
            exec join - "$1"
        fi
    }

    __r "${@:2}" < "$1"
fi

```
For every SRR id, the file contains 3 columns, `effective length`, `estimated counts` and `transcript per million`. And this is provided for every cDNA of At.




