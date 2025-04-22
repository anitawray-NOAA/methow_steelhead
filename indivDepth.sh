#!/bin/bash
#SBATCH --job-name=indivDepth
#SBATCH --output=/scratch2/mkardos/methowRAD/results/logs/indivDepth.log
#SBATCH -t 700:00:00
#SBATCH -c 1
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf
module load bio/vcftools/0.1.16
vcftools --gzvcf Methow_RAD.vcf.gz --depth --out Methow_RAD


