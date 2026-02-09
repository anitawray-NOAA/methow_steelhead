#!/bin/bash
#SBATCH --job-name=filter_methow_RAD_a
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/filter_methow_RAD_a.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --gzvcf Methow_RAD.vcf.gz --chr CM046570.1 --chr CM046571.1 --chr CM046572.1 --chr CM046573.1 --chr CM046574.1 --chr CM046575.1 --chr CM046576.1 --chr CM046577.1 --chr CM046578.1 --chr CM046579.1 --chr CM046580.1 --chr CM046581.1 --chr CM046582.1 --chr CM046583.1 --chr CM046584.1 --chr CM046585.1 --chr CM046586.1 --chr CM046587.1 --chr CM046588.1 --chr CM046589.1 --chr CM046590.1 --chr CM046591.1 --chr CM046592.1 --chr CM046593.1 --chr CM046594.1 --chr CM046595.1 --chr CM046596.1 --chr CM046597.1 --chr CM046598.1  --remove-indels --keep keepInds_depth --recode --out Methow_RAD_chroms_noIndels
vcftools --vcf Methow_RAD_chroms_noIndels.recode.vcf --min-meanDP 15 --max-meanDP 40 --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40.recode.vcf --minGQ 20 --minDP 6 --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6.recode.vcf --max-missing 0.7 --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7
vcftools --vcf Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7.recode.vcf --maf 0.01 --recode --out Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01

