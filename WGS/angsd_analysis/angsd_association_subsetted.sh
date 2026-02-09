#!/bin/bash
#SBATCH --output=/scratch2/awray/methow/output_files/output-asso-%A.txt
#SBATCH --ntasks=8
#SBATCH --job-name=angsd_gwas
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p standard
#SBATCH --array=1-29%3
#SBATCH --mem 50G

module load bio/angsd

cd /scratch2/awray/methow/angsd_GWAS/

PHENOS=' growth '
COVARIATES='Tank'
THREADS=8

name=`head -n ${SLURM_ARRAY_TASK_ID} /scratch2/awray/methow/docs/chr_list.txt | tail -1`

output_name="${name}_filtered.2PCs"

  angsd -yQuant growth_pheno.txt \
	-out $output_name \
       	-cov tank_and_2PC_cov.txt \
	-r $name \
  	-P $THREADS \
	-doAsso 2 \
    	-GL 2 \
    	-doPost 1 \
    	-doMajorMinor 1 \
    	-SNP_pval 1e-6 \
    	-doMaf 1 \
	-doCounts 1 \
	-bam /scratch2/awray/methow/docs/bamlist.txt \
    	-nind 243 \
    	-minMapQ 20 \
	-minMaf 0.05 \
    	-minInd 50 \
	-setMinDepth 384 \
	-setMaxDepth 755

