#!/bin/bash
#SBATCH --job-name=filter_methow_RAD_7
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/filter_methow_RAD_7.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9.recode.vcf --positions keepReadOneSNPsOnly --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_read1SNPsOnly





