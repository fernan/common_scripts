/bin/bash

#input file is
#a two column association between the index ID and the provided Sample ID
###Example INPUT file
#7492 LP-5615-F
#7493 LP-6188-F
#7494 LP-6186-F
#7495 LP-6184-F

#first column is a uniq identifier for the sample assigned by DNA sequencing facility
#second column is a more descriptive sample name to be attached.

while IFS='' read -r line || [[ -n "$line" ]]; do
#ADDR is just a variable for the line information ADDR[0] is the first column value and ADDR[1] is second column value for each line of SampleInfo.2col
read -ra ADDR <<< "$line"
tempR1=$(find ./ -name "${ADDR[0]}*R1*fastq")
tempR2=$(find ./ -name "${ADDR[0]}*R2*fastq")
cat $tempR1 | paste - - - - | sort -k1,1 -S 30G | tr '\t' '\n'  > ${ADDR[0]}_${ADDR[1]}_R1_001.fastq &
cat $tempR2 | paste - - - - | sort -k1,1 -S 30G | tr '\t' '\n'  > ${ADDR[0]}_${ADDR[1]}_R2_001.fastq &
wait

done < "Sample.2col" 
#end of while loop

#do some word counting to verify that the files that are being combined add up to the correct word count
#will need to check this by hand

find ./Sample* -name "*fastq" | xargs -I xx wc -l xx > counts.txt
wc -l *fastq > counts.combined.txt


