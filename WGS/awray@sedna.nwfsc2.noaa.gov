#!/bin/bash
#SBATCH --output=/scratch2/awray/methow/output_files/output-%A.txt
#SBATCH --ntasks=8
#SBATCH --job-name=angsd_filt
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p standard
#SBATCH --array=1-29%3
#SBATCH --mem 40G

module load bio/angsd

cd /scratch2/awray/methow/angsd_GWAS/

name=`head -n ${SLURM_ARRAY_TASK_ID} /scratch2/awray/methow/docs/chr_list.txt | tail -1`
THREADS=8
output_name="${name}_filtered_22426"

angsd \
	-out $output_name \
	-doCounts 1 \
	-dumpCounts 2 \
	-dumpCounts 1 \
	-doMajorMinor 1 \
	-GL 2 \
	-doGlf 2 \
	-r $name \
  	-P $THREADS \
  	-doPost 1 \
    -SNP_pval 1e-6 \
    -doMaf 1 \
	-bam /scratch2/awray/methow/docs/bamlist.txt \
    -nind 243 \
	-minMapQ 20 \
	-minMaf 0.05 \
    -minInd 50 \
	-setMinDepth 384 \
	-setMaxDepth 755










