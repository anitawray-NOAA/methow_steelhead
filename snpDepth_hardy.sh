#!/bin/bash
#SBATCH --job-name=snpDepth_hardy
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/snpDepth_hardy.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16


vcftools --gzvcf methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.5_mac2_minIndCov5_minHet3.recode.vcf.gz --hardy --out methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.5_mac2_minIndCov5_minHet3
vcftools --gzvcf methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.5_mac2_minIndCov5_minHet3.recode.vcf.gz --site-mean-depth --out methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.5_mac2_minIndCov5_minHet3.recode


