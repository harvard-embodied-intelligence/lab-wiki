#!/bin/zsh 
# 1. Read the optional index from command-line argument (defaults to 0)
index="${1:-0}"

# 2. Get the list of job IDs for user hbalim, skipping header (NR>1).
#    Then pick the job ID at zero-based index ($((index+1)) for sed -n).
job_id=$(squeue -u hbalim \
         | awk 'NR>1 {print $1}' \
         | sed -n "$((index + 1))p")

# 3. If a valid job_id was found, tail the corresponding .err file
if [[ -n "$job_id" ]]; then
    echo "Showing last 10 lines of ~/outputs/${job_id}.err"
    tail "$HOME/outputs/${job_id}.err"
else
    echo "No job found at index $index"
fi
