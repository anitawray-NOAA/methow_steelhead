#!/bin/bash
#SBATCH --output=/scratch2/awray/methow_RAD/output_files/output-asso-%A.txt
#SBATCH --ntasks=8
#SBATCH --job-name=angsd_gwas_RAD
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p himem
#SBATCH --array=1-29%2
#SBATCH --mem 300G

module load bio/angsd/0.933

cd /scratch2/awray/methow_RAD/

PHENOS=' growth '
COVARIATES='Tank'
THREADS=8

name=`head -n ${SLURM_ARRAY_TASK_ID} /scratch2/awray/methow/docs/chr_list.txt | tail -1`

output_name="${name}_filtered_RAD.2PCs"


#angsd sites index keepReadOneSNPsOnly.sorted

angsd	-bam bam_list_with_phenos_angsd.txt \
	-sites keepReadOneSNPsOnly.sorted \
	-doAsso 2 \
    	-GL 2 \
    	-doPost 1 \
    	-doMajorMinor 1 \
    	-SNP_pval 1e-6 \
    	-doMaf 1 \
	-doCounts 1 \
  	-yQuant growth_pheno_RAD_all_pops.txt \
	-out $output_name \
       	-cov RAD_tank_cov_all_pops_2PCs.txt \
	-r $name \
  	-P $THREADS

