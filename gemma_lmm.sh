#!/bin/bash

#SBATCH --job-name=gemma_smolt
#SBATCH --ntasks=2
#SBATCH -o out-%A.smolt_gemma_lmm.txt
#SBATCH -e error-%A.smolt_gemma_lmm.txt
#SBATCH --time=72:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL

module load bio/gemma/0.98.5

cd /home/awray/methow_steelhead/smoltification_GWAS

##run the linear mixed model
gemma -bfile Methow_RAD_filtered \
-k output/kinship.relate.cXX.txt \
-lmm 4 \
-c cov_file_tank_only.txt \
-o smoltification_lmm4
