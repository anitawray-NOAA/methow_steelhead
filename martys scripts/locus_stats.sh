#!/bin/bash
#SBATCH --job-name=locus_stats
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/locus_stats.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_maxMiss0.8.recode.vcf --site-mean-depth --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.9_minGenoDP12_maxMiss0.8

