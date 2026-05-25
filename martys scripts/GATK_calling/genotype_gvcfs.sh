#!/bin/bash
#SBATCH --job-name=genotype_gvcfs
#SBATCH --output=../logs/genotype_gvcfs.%A.%a.log
#SBATCH --array=1-29
#SBATCH -t 400:00:00
#SBATCH -c 5
#SBATCH -D /scratch2/mkardos/methowRAD/results/gvcf


case $SLURM_ARRAY_TASK_ID in
1) IN=CM046570.1 ;;
2) IN=CM046571.1 ;;
3) IN=CM046572.1 ;;
4) IN=CM046573.1 ;;
5) IN=CM046574.1 ;;
6) IN=CM046575.1 ;;
7) IN=CM046576.1 ;;
8) IN=CM046577.1 ;;
9) IN=CM046578.1 ;;
10) IN=CM046579.1 ;;
11) IN=CM046580.1 ;;
12) IN=CM046581.1 ;;
13) IN=CM046582.1 ;;
14) IN=CM046583.1 ;;
15) IN=CM046584.1 ;;
16) IN=CM046585.1 ;;
17) IN=CM046586.1 ;;
18) IN=CM046587.1 ;;
19) IN=CM046588.1 ;;
20) IN=CM046589.1 ;;
21) IN=CM046590.1 ;;
22) IN=CM046591.1 ;;
23) IN=CM046592.1 ;;
24) IN=CM046593.1 ;;
25) IN=CM046594.1 ;;
26) IN=CM046595.1 ;;
27) IN=CM046596.1 ;;
28) IN=CM046597.1 ;;
29) IN=CM046598.1 ;;
esac

module load bio/gatk/4.2.0.0
 gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R /scratch2/mkardos/methowWGS/resources/GCA_025558465.1_Omyk_2.0_genomic.fasta \
   -V gendb://genomeDB/genomedb_${IN} \
   -O ${IN}.vcf.gz

