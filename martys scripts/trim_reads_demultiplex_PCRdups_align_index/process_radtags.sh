#!/bin/bash
#SBATCH --job-name=process_rad_tags
#SBATCH --output=results/logs/demultiplex_logfile.%A.%a.log
#SBATCH --array=1-16
#SBATCH -t 400:00:00
#SBATCH -c 10
#SBATCH -D /scratch2/mkardos/methowRAD

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

module load bio/stacks/2.62
process_radtags -1 ./results/trimmed/JDRAD-${INFILE}_R1_001_trimmed_paired.fastq.gz  -2 ./results/trimmed/JDRAD-${INFILE}_R2_001_trimmed_paired.fastq.gz --paired -b ./resources/barcodes.txt -o ./results/indsamps/${INFILE} -e sbfI --threads 10 -c -q -r --bestrad

