#!/bin/bash
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz
tar -zxvf taxdb.tar.gz

module load ncbi-blast
FASTA="$1"
blastn \
-task megablast \
-query ${FASTA} \
-db /work/GIF/GIF3/arnstrm/Baum/GenePrediction_Hg_20160115/05_databases/nt/nt \
-outfmt '6 qseqid staxids bitscore std sscinames sskingdoms stitle' \
-culling_limit 5 \
-num_threads 16 \
-evalue 1e-25 \
-out ${FASTA%.**}.vs.nt.cul5.1e25.megablast.out
