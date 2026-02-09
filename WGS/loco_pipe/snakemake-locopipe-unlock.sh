#!/bin/bash

#SBATCH --job-name=sm-unlock
#SBATCH --ntasks=1
#SBATCH --time=1:00:00
#SBATCH --mail-user=anita.wray@noaa.gov
#SBATCH --mail-type=ALL
#SBATCH -p standard

source ~/.bashrc
mamba activate loco-pipe

cd /scratch2/awray/loco-pipe

BASEDIR=/scratch2/awray/methow


#run with -np flag first to do dry-run
snakemake \
	--use-conda \
	--printshellcmds \
	--rerun-incomplete \
	--profile workflow/profiles/slurm/ \
	--configfile ../methow/config/config.yaml \
	--snakefile workflow/pipelines/loco-pipe.smk \
	--unlock


mamba deactivate

exit

