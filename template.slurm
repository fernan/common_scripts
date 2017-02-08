#!/bin/bash
#SBATCH -J jobname
#SBATCH -N 1 
#SBATCH --ntasks-per-node=16 
#SBATCH -t 24:00:00
#SBATCH -o $SLURM_JOB_NAME.o%j
#SBATCH -e $SLURM_JOB_NAME.e%j
#SBATCH --mail-user=arnstrm@gmail.com
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
cd $SLURM_SUBMIT_DIR
module load name
