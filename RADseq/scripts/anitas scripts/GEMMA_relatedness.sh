#!/bin/bash

#SBATCH --job-name=gemma_relatedness
#SBATCH --ntasks=1
#SBATCH -o out-smoltification_relatedness_gemma.txt
#SBATCH -e error-smoltification_relatedness_gemma.txt
#SBATCH --time=72:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL

module load bio/gemma/0.98.5

cd /home/awray/methow_steelhead/smoltification_GWAS
 
##create relatedness matrix (centered is best recommendation for starting off in the documentation)
gemma -bfile Methow_RAD_filtered \
 -p phen_file_SI_code_only.txt -gk 1 \
 -o kinship.relate


