#!/bin/bash

#SBATCH --job-name=Rclone_MKardos

#SBATCH -o %x_%j.out

#SBATCH -e %x_%j.err

#SBATCH --mail-user=anita.wray@noaa.ggov

#SBATCH --mail-type=ALL

#SBATCH -c 5

#SBATCH -t 240:0:0

module load tools/rclone

rclone copy -P --transfers 5 --drive-shared-with-me --bwlimit 8.5M /share/nwfsc/mkardos/MethowRAD_1 gdrive:"RAD & WGS 2021-"/"RAW SEQUENCE FILES"/"RADseq"

rclone copy -P --transfers 5 --drive-shared-with-me --bwlimit 8.5M /scratch/afraik Mia:"Alex_sednafiles"/scratch