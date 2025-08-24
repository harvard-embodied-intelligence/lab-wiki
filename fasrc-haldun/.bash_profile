# .bash_profile
if [[ $- == *i* ]] && [[ -z "$SLURM_JOB_ID" ]]; then
  exec zsh -l
fi
