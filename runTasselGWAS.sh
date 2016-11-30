#!/bin/bash
module load tassel
VCF="$1"
TRAITS="/data021/GIF/arnstrm/Purcell/albacore/08_Tassel/vcf_files/pheno_traits.txt"

${TASSEL_HOME}/run_pipeline.pl -fork1 -importGuess ${VCF} -ImputationPlugin -ByMean true -nearestNeighbors 5 -distance Euclidean -endPlugin -export ${VCF%.*}_imputed -exportType VCF

${TASSEL_HOME}/run_pipeline.pl -fork2 -importGuess ${VCF%.*}_imputed.vcf -KinshipPlugin -method Centered_IBS -endPlugin -export ${VCF%.*}_kinship.txt -exportType SqrMatrix

${TASSEL_HOME}/run_pipeline.pl -fork3 -importGuess ${VCF%.*}_imputed.vcf -importGuess ${VCF%.*}_kinship.txt -importGuess ${TRAITS} -FixedEffectLMPlugin -maxP 1.0 -permute true -nperm 1000 -biallelicOnly false -siteStatsOut true -endPlugin -export ${VCF%.*}_glm_output
