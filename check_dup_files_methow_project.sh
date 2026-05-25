#!/bin/bash
#SBATCH --job-name=checksums_methow

#SBATCH -o %x_%j.out

#SBATCH -e %x_%j.err

#SBATCH --mail-user=anita.wray@noaa.ggov

#SBATCH --mail-type=ALL

#SBATCH -c 5

#SBATCH -t 240:0:0

cd /share/nwfsc/mkardos

Set the output file name
OUTPUT_FILE="checksums_methow_proj.csv"

Write the CSV header
echo "Filename,MD5sum" > "${OUTPUT_FILE}"

Find all files, calculate md5sum, and append to the CSV file
The find command locates all regular files (-type f) in the current directory (.) and its subdirectories.
The -print0 option prints the full file path followed by a null character. This is safer than newlines for file names that contain spaces or other special characters.
The xargs -0 option reads the null-terminated input from find.
The md5sum command calculates the MD5 hash for each file.
The awk command then processes the output of md5sum to reformat it.
awk '{print $2","$1}' prints the filename ($2) followed by a comma, and then the md5sum ($1).
The >> appends the output to the specified CSV file.
find . -type f -print0 | xargs -0 md5sum | awk '{print $2","$1}' >> "${OUTPUT_FILE}"