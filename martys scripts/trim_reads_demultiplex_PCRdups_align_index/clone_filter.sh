#!/bin/bash
#SBATCH --job-name=clone_fiter
#SBATCH --output=../logs/clone_filter.%A.%a.log
#SBATCH --array=1-16
#SBATCH -p medmem
#SBATCH -t 400:00:00
#SBATCH -c 20
#SBATCH -D /scratch2/mkardos/methowRAD/results/trimmed

case $SLURM_ARRAY_TASK_ID in
        1) INFILE=01 ;;
        2) INFILE=02 ;;
        3) INFILE=03 ;;
        4) INFILE=04 ;;
        5) INFILE=05 ;;
        6) INFILE=06 ;;
        7) INFILE=07 ;;
        8) INFILE=08 ;;
        9) INFILE=09 ;;
        10) INFILE=10 ;;
        11) INFILE=11 ;;
        12) INFILE=12 ;;
        13) INFILE=13 ;;
        14) INFILE=14 ;;
        15) INFILE=15 ;;
        16) INFILE=16 ;;
esac

module load bio/stacks/2.65
clone_filter -1 JDRAD-01_R1_001_trimmed_paired.fastq.gz -2 JDRAD-01_R2_001_trimmed_paired.fastq.gz -i gzfastq -o ./clone_filtered/
