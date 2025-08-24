#!/usr/bin/zsh

# Name: status_all

# Retrieve all job IDs for user 'hbalim'
job_ids=( $(squeue -u hbalim | awk 'NR>1 {print $1}') )

# If no jobs are found, exit early
if [ ${#job_ids[@]} -eq 0 ]; then
  echo "No jobs found for user hbalim."
  exit 0
fi

# For each job ID, tail the corresponding .err file
for job_id in "${job_ids[@]}"; do
    echo "===== Tailing job $job_id ====="
    
    file="$HOME/outputs/$job_id.err"
    if [ -f "$file" ]; then
        tail -n 10 "$file"
    else
        echo "Error file not found: $file"
    fi
    
    echo "--------------------------------"
done
