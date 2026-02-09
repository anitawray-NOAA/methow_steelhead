#!/bin/bash

#SBATCH --job-name=loco-pipe
#SBATCH --mem=1G
#SBATCH --ntasks=2
#SBATCH -e /scratch2/awray/methow/output_files/output-%A.sm.txt
#SBATCH --time=100:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p standard

source ~/.bashrc
mamba activate loco-pipe

cd /scratch2/awray/loco-pipe

#run with -np flag first to do dry-run
snakemake \
	--use-conda \
	--printshellcmds \
	--rerun-incomplete \
	--profile workflow/profiles/slurm/ \
	--configfile ../methow/config/config.yaml \
	--snakefile workflow/pipelines/loco-pipe.smk


mamba deactivate

exit

