#!/bin/bash

#SBATCH --job-name=pcangsd_RAD
#SBATCH --ntasks=8
#SBATCH -o /scratch2/awray/methow_RAD/output_files/output-RAD_angsd_pcangsd.txt
#SBATCH --time=240:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH --mem 300G
#SBATCH -p himem

# --array=20


module load bio/angsd

cd /scratch2/awray/methow_RAD/


#name=`head -n ${SLURM_ARRAY_TASK_ID} /scratch2/awray/methow/docs/chr_list.txt | tail -1`

#output_name="${name}_filtered_RAD"

#angsd -bam bam_list_with_phenos_angsd.txt \
#	-sites  keepReadOneSNPsOnly.sorted \
#	-GL 2 \
#	-doGlf 2 \
#	-doMaf 1 \
#	-doMajorMinor 1 \
#	-doDepth 1 -doCounts 1 \
#	-doIBS 1 -makematrix 1 -doCov 1 \
#        -P 8 \
#	-out $output_name \
#	-r $name

module load bio/pcangsd/1.36.4

pcangsd \
	--beagle RAD_concatenated_fixed.beagle \
	--snp-weights \
	--threads 8 \
	--out pcangsd_all_pops_all_phenos
