#!/bin/bash

#SBATCH --job-name=GCTA_GWAS
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH -p standard
#SBATCH -c 8
#SBATCH --mem=32GB
#SBATCH -t 48:00:00

################################################################################
# This script requires:
# 1. PLINK files (.bed, .bim, .fam)
# 2. a phenotype file (.pheno)
# 3. a covariate file (.txt) 

# The script will perform two main steps:
# 1. Calculate the Genetic Relationship Matrix (GRM).
# 2. Run the mixed-linear model association analysis (MLMA) with a covariate.
################################################################################

module load bio/GCTA

cd /home/awray/methow_steelhead/GCTA_gwas

###### ENVIRONMENT SETUP ########

# Prefix for your PLINK files (.bim/.bam/.fam)
PLINK_PREFIX="Methow_RAD_chroms_noIndels_minDP15_maxDP40_minGQ20_minGenDP6_maxMiss0.7_maf0.01_noParalogs_maxMiss0.8.recode_PLINK_filtered"

# Phenotype file
# This file should have three columns: FID, IID, and the phenotype value.
PHENOTYPE_FILE="phen_file_growth_only_GCTA.txt"

# Covariate file
# This file should have three columns: FID, IID, and the covariate value.
COVAR_FILE="cov_file_tank_only_GCTA.txt"

# Output directory and prefix for the results
OUTPUT_DIR="gcta_results"
OUTPUT_PREFIX="gwas_growth_run1"

# Create the output directory if it doesn't exist
#mkdir -p "$OUTPUT_DIR"

######  CALCULATE THE GENETIC RELATIONSHIP MATRIX (GRM) #######
echo "Step 1: Calculating GRM..."
gcta64 --make-grm \
        --bfile "${PLINK_PREFIX}" \
        --out "${OUTPUT_DIR}/${OUTPUT_PREFIX}" \
        --thread-num 8 \
       	--autosome-num 29

###### PERFORM MIXED-LINEAR MODEL ASSOCIATION (MLMA) ANALYSIS ######
echo "Step 2: Performing MLMA association analysis with covariates..."
gcta64 --mlma \
        --bfile "${PLINK_PREFIX}" \
        --pheno phen_file_growth_only_GCTA.pheno\
	--grm "${OUTPUT_DIR}/${OUTPUT_PREFIX}" \
        --covar "${COVAR_FILE}" \
        --out "${OUTPUT_DIR}/${OUTPUT_PREFIX}" \
	--autosome-num 29 \
	--thread-num 8

echo "Results are in the '$OUTPUT_DIR' directory. Output is in %x.%j.out"
