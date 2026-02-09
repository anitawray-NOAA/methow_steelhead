#!/bin/bash
#SBATCH --job-name=make_plink_bed_gemma
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/make_plink_bed_gemma.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/plink/1.90b6.23
plink --file growth --chr-set 29 --make-bed --out growth
plink --file smolt --chr-set 29 --make-bed --out smolt



