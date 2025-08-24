#!/bin/zsh

# Usage check
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <slurm_template> [<num_gpus>] <cmd1> ['<cmd2>' ...]"
  exit 1
fi

# Parse template and shift
slurm_template="$1"
shift

# Validate SLURM template
if [ ! -f "$slurm_template" ]; then
  echo "Error: SLURM template file '$slurm_template' does not exist."
  exit 1
fi

# Determine if next arg is a number (num_gpus)
if [[ "$1" =~ ^[0-9]+$ ]]; then
  num="$1"
  shift
else
  num=1
fi

# Remaining args are commands
cmds=("$@")

# Validate number of GPUs
if ! [[ "$num" =~ ^[0-9]+$ ]] || [ "$num" -le 0 ]; then
  echo "Error: <num_gpus> must be a positive integer"
  exit 1
fi

# Handle command count
if [ "${#cmds[@]}" -eq 1 ]; then
  # Duplicate single command
  original="${cmds[0]}"
  cmds=()
  for ((i = 0; i < num; i++)); do
    cmds+=("$original")
  done
elif [ "${#cmds[@]}" -ne "$num" ]; then
  echo "Error: You must provide either 1 command or exactly $num commands."
  exit 1
fi

# Generate unique hash
hash=$(echo "$slurm_template ${cmds[*]}" | md5sum | awk '{print $1}')
target_dir=~/spawned-scripts
mkdir -p "$target_dir"

# Script paths
script_base="spawn-job-${hash}"
command_script="${target_dir}/${script_base}.sh"
slurm_script="${target_dir}/${script_base}.slurm"

# Generate command script to run inside SLURM job
cat > "$command_script" <<'EOF'
#!/bin/bash
echo "Detecting GPU UUIDs inside SLURM job..."

# Extract MIG UUIDs
uuid_list=($(nvidia-smi -L | grep 'UUID:' | grep 'MIG-' | sed -E 's/.*UUID: (MIG-[^)]*).*/\1/'))

# Fallback to full GPU UUIDs if MIG not found
if [ "${#uuid_list[@]}" -eq 0 ]; then
  uuid_list=($(nvidia-smi -L | grep 'UUID:' | sed -E 's/.*UUID: ([^)]*).*/\1/'))
fi

if [ "${#uuid_list[@]}" -lt NUM_PLACEHOLDER ]; then
  echo "Error: fewer GPU UUIDs available than required."
  exit 1
fi

echo "Found GPU UUIDs and assigned commands:"
cmd_list=(
EOF

# Add the command list array in shell syntax
for cmd in "${cmds[@]}"; do
  echo "  \"${cmd}\"" >> "$command_script"
done

cat >> "$command_script" <<'EOF'
)

for i in "${!uuid_list[@]}"; do
  echo "  [$i] → ${uuid_list[$i]} -> ${cmd_list[$i]}"
done

echo "Launching parallel commands:"
EOF

# Append commands with GPU binding using UUIDs
for i in "${!cmds[@]}"; do
  echo "( export PROC_IDX=$i; export CUDA_VISIBLE_DEVICES=\${uuid_list[$i]}; ${cmds[$i]} ) &" >> "$command_script"
done

# Finalize command script
echo "wait" >> "$command_script"
chmod +x "$command_script"

# Extract base memory value from the SLURM template
mem_per_task=$(grep -E '^#SBATCH --mem=[0-9]+' "$slurm_template" | sed -E 's/^#SBATCH --mem=([0-9]+)/\1/')

if ! [[ "$mem_per_task" =~ ^[0-9]+$ ]]; then
  echo "Error: Failed to extract memory from template. Expected line like '#SBATCH --mem=8000'"
  exit 1
fi

# Substitute resource placeholders
num_cpus=$((num * 4))
mem_mb=$((num * mem_per_task))

# Generate SLURM job script by substituting placeholders
sed \
  -e "s|{{NUM_GPUS}}|${num}|g" \
  -e "s|{{NUM_CPUS}}|${num_cpus}|g" \
  -e "s|{{COMMAND_SCRIPT}}|${command_script}|g" \
  "$slurm_template" | \
  sed -E "s|^#SBATCH --mem=[0-9]+|#SBATCH --mem=${mem_mb}|" \
  > "$slurm_script"

# Replace placeholder in command script
sed -i "s/NUM_PLACEHOLDER/${num}/g" "$command_script"
chmod +x "$slurm_script"

# Submit job
sbatch "$slurm_script"
