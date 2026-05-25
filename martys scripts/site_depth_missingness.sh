#!/bin/bash
#SBATCH --job-name=site_depth_missingness
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/site_depth_missingness.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --gzvcf methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.7_mac2.recode.vcf --site-depth --out methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.7_mac2
vcftools --gzvcf methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.7_mac2.recode.vcf --missing-site --out methow_rad_chrsOnly_noIndels_maxMiss0.5_minDP5_maxDP40_minGQ20_maxMiss0.7_mac2


