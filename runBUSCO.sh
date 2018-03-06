#!/bin/bash
# runs the busco pipeline on the genome assesment mode
# if your genome is not plan change the select the suitable option below
# run it as:
# sh runBUSCO_genome.sh genome.fasta OrganismProfile
# Arun Seetharam
# 2015/10/09 <arnstrm@iastate.edu>
#
#
# SELECT ONE OF THE BELOW ORGANISM PROFILES
#
#ORG=actinopterygii_odb9
#ORG=arthropoda_odb9
#ORG=ascomycota_odb9
#ORG=aves_odb9
#ORG=basidiomycota_odb9
#ORG=dikarya_odb9
#ORG=diptera_odb9
#ORG=embryophyta_odb9
#ORG=endopterygota_odb9
#ORG=euarchontoglires_odb9
#ORG=eukaryota_odb9
#ORG=eurotiomycetes_odb9
#ORG=fungi_odb9
#ORG=hymenoptera_odb9
#ORG=insecta_odb9
#ORG=laurasiatheria_odb9
#ORG=mammalia_odb9
#ORG=metazoa_odb9
#ORG=microsporidia_odb9
#ORG=nematoda_odb9
#ORG=pezizomycotina_odb9
#ORG=saccharomycetales_odb9
#ORG=saccharomyceta_odb9
#ORG=sordariomyceta_odb9
#ORG=tetrapoda_odb9
#ORG=vertebrata_odb9

#
# SELECT ONE MODE BELOW
#
MODE=genome
#MODE=transcriptome
#MODE=proteins

# results will be stored in the new directroy with the genome suffix
if [ $# -lt 2 ] ; then
echo "please specify both your genome and the organism profile you wish to use";
exit;
fi

module use /work/GIF/software/modules
module load GIF/busco/2.0
genome="$1"
ORG="$2"
outname=$(basename ${genome%.*})
export AUGUSTUS_CONFIG_PATH="$AUGUSTUS_CONFIG_PATH;./config"

python3 ${BUSCO_HOME}/BUSCO.py \
  -o ${outname} \
  -i ${genome} \
  -l ${BUSCO_HOME}/${ORG} \
  -m ${MODE} \
  -c 16 \
  -f
