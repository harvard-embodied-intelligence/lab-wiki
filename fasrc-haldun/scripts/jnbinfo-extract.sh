#!/bin/zsh

# Check if a filename was provided
if [ $# -eq 0 ]; then
    echo "Please provide a filename as an argument."
    exit 1
fi

filename="$1"

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

# Extract the Remote IP
remote_ip=$(grep -m 1 -oP 'Remote IP:\K[0-9.]+' "$filename")

if [ -z "$remote_ip" ]; then
    echo "Remote IP not found in the file."
    exit 1
fi

# Extract the first URL starting with http://127.0.0.1
url=$(grep -m 1 -oP 'http://127\.0\.0\.1:[0-9]+/tree\?token=[a-zA-Z0-9]+' "$filename")

if [ -z "$url" ]; then
    echo "No matching URL found in the file."
    exit 1
fi

# Extract the remote port from the URL
remote_port=$(echo "$url" | grep -oP '(?<=:)[0-9]+(?=/)')

if [ -z "$remote_port" ]; then
    echo "Remote port not found in the URL."
    exit 1
fi

# Print the first line of the file
date=$(head -n 1 "$filename")
echo "Date: $date"

# Print the extracted URL
echo "Extracted URL: $url"

# Construct and print the SSH command
echo "SSH Command: ssh -f hbalim@login.rc.fas.harvard.edu -L 8888:$remote_ip:$remote_port -N"

