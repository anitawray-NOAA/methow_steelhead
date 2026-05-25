#!/bin/bash
#SBATCH --job-name=genoStats_methow_RAD
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/genoStats_methow_RAD.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01.recode.vcf --depth --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01.recode.vcf --missing-indv --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01.recode.vcf --site-mean-depth --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01.recode.vcf --missing-site --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ30_maxMiss0.7_maf0.01
