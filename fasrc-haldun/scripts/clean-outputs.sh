#!/bin/zsh

# Directory to search for files
output_dir="/n/home04/hbalim/outputs"

# Get the list of job IDs to preserve
preserve_array=("${(@f)$(squeue -u hbalim | awk 'NR>1 {print $1}')}")

# Iterate over all files in the specified directory
for file in "$output_dir"/*; do
    # Skip if no files match the wildcard
    [[ -e "$file" ]] || continue

    # Initialize a flag to check if the file matches any job ID
    keep_file=false

    # Get the base name of the file (exclude the directory path)
    filename=$(basename "$file")

    # Extract the first 8 characters of the base filename
    first_eight_chars="${filename:0:8}"
    
    # Check if the first 8 characters match any of the job IDs
    for job_id in $preserve_array; do
        if [[ "$first_eight_chars" == "$job_id" ]]; then
	    keep_file=true
            break
        fi
    done

    # If the file does not match any job ID, delete it
    if [[ $keep_file == false ]]; then
	echo "$file"
        rm -f "$file"
    fi
done

