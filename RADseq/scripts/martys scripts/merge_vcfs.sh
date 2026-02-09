#!/bin/bash
#SBATCH --job-name=merge_vcfs
#SBATCH --output=../logs/merge_vcfs.log
#SBATCH -t 400:00:00
#SBATCH -c 5
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf

module load bio/gatk/4.2.0.0
 gatk --java-options "-Xmx4g" MergeVcfs \
          I=input_variants.list \
          O=Methow_RAD.vcf.gz
