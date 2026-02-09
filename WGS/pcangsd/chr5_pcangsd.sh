#!/bin/bash
#SBATCH --output=/scratch2/awray/methow/output_files/output-chr5pca-%A.txt
#SBATCH --ntasks=8
#SBATCH --job-name=pcangsd
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p standard
#SBATCH --time 05:00:00

##environment loading
module load bio/pcangsd/1.36.4 

input="/scratch2/awray/methow/angsd/snp_calling_global/CM046574.1.beagle.gz"

echo $input

##run pcangsd
cd /scratch2/awray/methow
mkdir chr5_pcangsd

## run pcangsd for PCA only
pcangsd \
    --beagle $input \
    --snp-weights \
    --sites-save \
    --maf 0.01 \
    --threads 8 \
    -o chr5_pcangsd 
