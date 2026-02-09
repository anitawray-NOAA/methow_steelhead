#!/bin/bash

#SBATCH --job-name=pcangsd_RAD
#SBATCH --ntasks=8
#SBATCH -o output-RAD_pcangsd.txt
#SBATCH --time=240:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL


cd /scratch2/awray/methow_RAD/

module load bio/pcangsd/1.36.4

pcangsd \
	--beagle RAD_concatenated_fixed.beagle.gz \
	--snp-weights \
	--threads 8 \
	--out pcangsd_all_pops_all_phenos
