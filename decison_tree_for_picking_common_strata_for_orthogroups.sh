#!/bin/bash
# DATA LOOKS LIKE THIS
#OGGROUP PS_TYPES        GENES   PS1     PS1_FREQ        PS2     PS2_FREQ        PS1_PC  PS2_PC
#OG2.5_10001     2       9       17      1       18      8       11.1111 88.8889
#OG2.5_10008     2       9       10      2       7       7       22.2222 77.7778
#OG2.5_10010     2       9       17      8       16      1       88.8889 11.1111
#OG2.5_10012     2       8       2       7       4       1       87.5    12.5
#OG2.5_10013     2       9       10      8       5       1       88.8889 11.1111
#OG2.5_10014     2       10      4       7       3       3       70      30
#OG2.5_10016     2       10      1       1       2       9       10      90
#OG2.5_10020     2       9       10      8       12      1       88.8889 11.1111
#OG2.5_10027     2       9       8       8       9       1       88.8889 11.1111

file=$1
while read -ra line; do
OGGROUP=${line[0]};
PS_TYPES=${line[1]};
GENES=${line[2]};
PS1=${line[3]};
PS1_FREQ=${line[4]};
PS2=${line[5]};
PS2_FREQ=${line[6]};
PS1_PC=${line[7]};
PS2_PC=${line[8]};
TPS1=$(echo "$PS1" |cut -f 1 -d "-")
TPS2=$(echo "$PS2" |cut -f 1 -d "-")
TPC1=$(echo "$PS1_PC" |cut -f 1 -d ".")
TPC2=$(echo "$PS2_PC" |cut -f 1 -d ".")
PSDIFF=$(echo $(( TPS1 - TPS2 )) | tr -d "-")

echo "starting the decison tree for the orthogroup $OGGROUP" 1>&2
echo "this group has $PS_TYPES strata, $PS1 and $PS2. After trimming, they are $TPS1 and $TPS2" 1>&2
echo "they occur in $PS1_PC ( $PS1_FREQ out of ${GENES}) and $PS2_PC ( $PS2_FREQ out of ${GENES})" 1>&2
echo "absolute diff between strata is $PSDIFF, let's begin!" 1>&2
if [[ ${TPS1} -eq ${TPS2} ]]; then
   echo "no further testing needed, the trimmed ps is same for both strata in this OG" 1>&2
   echo -e "${OGGROUP}\t$TPS1"
elif [[ ${TPC1} -gt 80 ]]; then
   echo "first strata is greater than 80%, now checking if it is also the lowest" 1>&2
   if [[ $TPS1 -lt $TPS2 ]]; then
      echo "first strata is the lowest, picking it as the strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS1"
   elif [[ $PSDIFF -le 3 ]]; then
      echo "first strata is not lowest, but, difference between 2 strata is <= 3 levels, hence we will select the second strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS2"
   elif [[ $GENES -gt 10 ]]; then
      echo "first strata is not lowest nor the difference between 2 strata is <= 3 levels, but since there >10 genes and most of it point first strata, we will select the first strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS1"
   elif [[ $PS2_FREQ -eq 1 ]]; then
      echo "first strata is not lowest nor the difference between 2 strata is <= 3 levels, but since only one gene is supporting the second strata, we will select the first strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS1"
   else
      echo "2a3a: unable to decide strata for this OG" 1>&2
      echo -e "${OGGROUP}\tNA"
   fi
elif [[ ${TPC2} -gt 80 ]]; then
   echo "second strata is greater than 80%, now checking if it is also the lowest" 1>&2
   if [[ $TPS2 -lt $TPS1 ]]; then
      echo "second strata is the lowest, picking it as the strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS2"
   elif [[ $PSDIFF -le 3 ]]; then
      echo "second strata is not lowest, but, difference between 2 strata is <= 3 levels, hence we will select the first strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS1"
   elif [[ $GENES -gt 10 ]]; then
      echo "second strata is not lowest nor the difference between 2 strata is <= 3 levels, but since there >10 genes and most of it point second strata, we will select the second strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS2"
   elif [[ $PS1_FREQ -eq 1 ]]; then
      echo "second strata is not lowest nor the difference between 2 strata is <= 3 levels, but since only one gene is supporting the first strata, we will select the second strata for this OG" 1>&2
      echo -e "${OGGROUP}\t$TPS2"
   else
      echo "2a3a: unable to decide strata for this OG" 1>&2
      echo -e "${OGGROUP}\tNA"
   fi
elif [[ $TPC1 -eq $TPC2 ]]; then
   echo "both strata have equal proportion, now checking if there are enough genes or the difference between strata to decide" 1>&2
   if [[ $GENES -gt 3 || $PSDIFF -le 3 ]]; then
      echo "there are more than 4 genes or the difference between the 2 strata is <=3, will pick the lowest strata for this OG" 1>&2
      if [[ $TPS1 -lt $TPS2 ]]; then
         echo "first strata is lowest, selecting this for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS1"
      else
         echo "second strata is lowest, selecting this for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS2"
      fi
  else
      echo "2b1a and 2b1b: unable to decide strata for this OG" 1>&2
      echo -e "${OGGROUP}\tNA"
   fi
elif [[ $TPC1 -ne $TPC2 ]]; then
   echo "not in equal proportion, now checking if there are enough genes or the difference between strata to decide" 1>&2
   if [[ $GENES -gt 3 &&  $PSDIFF -le 3 ]]; then
      echo "there are more than 4 genes and the ps difference is <=3, will pick the lowest strata for this OG" 1>&2
      if [[ $TPS1 -lt $TPS2 ]]; then
         echo "first strata is lowest, selecting this for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS1"
      else
         echo "second strata is lowest, selecting this for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS2"
      fi
   elif [[ $GENES -gt 3 ]]; then
      echo "there are more than 4 genes, will check if strata frequency to pick OG" 1>&2
      if [[ $PS1_FREQ -lt $PS2_FREQ && $PS1_FREQ -eq 1 ]]; then
         echo "first strata strata has freq of 1, selecting second for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS2"
      elif [[ $PS2_FREQ -lt $PS1_FREQ && $PS2_FREQ -eq 1 ]]; then
         echo "second strata strata has freq of 1, selecting first for OG" 1>&2
         echo -e "${OGGROUP}\t$TPS1"
      else
         echo "2b1c: unable to decide strata for this OG" 1>&2
         echo -e "${OGGROUP}\t$NA"
      fi

   else
      echo "2b1a and 2b1b: unable to decide strata for this OG" 1>&2
      echo -e "${OGGROUP}\tNA"
   fi
fi
echo "done processing the ${OGGROUP}!" 1>&2

done<"${file}"
