#!/bin/zsh
# ~/.zprofile: executed by the command interpreter for login shells.
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# User specific environment and startup programs
[[ -s /n/home04/hbalim/.autojump/etc/profile.d/autojump.sh ]] && source /n/home04/hbalim/.autojump/etc/profile.d/autojump.sh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
export PATH=$PATH:/n/home04/hbalim
eval "$(starship init zsh)"
export LAB_DIR='/n/netscratch/nali_lab_seas/Lab/hbalim/'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco210/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia
export CPATH=$CONDA_PREFIX/include
# modules (be considerate while adding)

# aliases
alias orc='nano $HOME/.zprofile'
alias rrc='source $HOME/.zprofile'
alias me='squeue -u hbalim'
alias count-jobs='echo $(( $(me | wc -l) - 1 ))'
alias watch-me='watch -n 1 "squeue -u hbalim"'
alias meq='showq -o -p gpu_requeue | grep hbalim'
alias show-req='showq -o -p gpu_requeue'
alias meq-seas='showq -o -p seas_gpu | grep hbalim'
alias show-seas='showq -o -p seas_gpu'
alias meq-test='showq -o -p gpu_test | grep hbalim'
alias show-test='showq -o -p gpu_test'
alias share='sshare --account=nali_lab_seas -a'
alias share-ydu='sshare --account=kempner_ydu_lab -a'
alias cancel-all="scancel -u hbalim"
alias status='zsh ~/scripts/status.sh'
alias watch-status='watch -n 1 "zsh ~/scripts/status.sh"'
alias status-all='zsh ~/scripts/status-all.sh'
alias interactive="srun --nodes=1 --mem 16000 -c 8 --time=04:00:00 -p test --pty zsh -c 'source ~/.bash_profile; exec zsh -i'"
alias interactive-gpu="srun --nodes=1 --mem 16000 -c 8 --time=04:00:00 -p gpu_test --gres=gpu:1 --pty zsh -c 'source ~/.bash_profile; exec zsh -i'"
alias interactive-ydu="srun --nodes=1 --mem 16000 -c 8 --time=04:00:00 -p kempner_interactive --gres=gpu:1 --account=kempner_ydu_lab --pty zsh -c 'source ~/.bash_profile; exec zsh -i'"
alias lmods='module load $(cat $HOME/scripts/default-modules-gpu)'
alias lmods-cpu='module load $(cat $HOME/scripts/default-modules)'
alias jnb="sbatch ~/scripts/jupyter"
alias jnb-gpu="sbatch ~/scripts/jupyter-gpu"
alias jnb-gpu-test="sbatch ~/scripts/jupyter-gpu-test"
alias sctrl='scontrol show job -dd'
alias jnbex="zsh ~/scripts/jnbinfo-extract.sh ~/jnbinfo"
alias where="echo fasrc"
alias clean-outputs="zsh ~/scripts/clean-outputs.sh"
alias cpu-task="srun -J cpu-task -c 8 -t 0-23:59 -p serial --mem=16000 -o /n/home04/hbalim/outputs/%j.out -e /n/home04/hbalim/outputs/%j.err"
alias storage='df -h ~'
alias njobs="squeue | wc -l | awk '{print \$1 - 1}'"

export WANDB_CACHE_DIR=$LAB_DIR
multi() {
    local n=$1        # The number of times to run the command
    shift             # Shift arguments so that $@ now contains the command and its arguments
    for ((i=0; i<n; i++)); do
        echo "Running: $@"
        "$@" &
	sleep 1
    done
    wait
}
vact() {
    local venv="${1:-default}"
    source ~/venvs/"$venv"/bin/activate
}
pip-ver() {
	pip list | grep $1
}
spawn() {
    bash "$HOME/scripts/spawn.sh" "$@"
}
spawn-gpu() {
    spawn "$HOME/scripts/spawn-gpu" "$@"
}
spawn-ydu(){
   spawn "$HOME/scripts/spawn-ydu" "$@"
}
spawn-gpu-test(){
    spawn "$HOME/scripts/spawn-gpu-test" "$@"
}
spawn-gpu-req(){
    spawn "$HOME/scripts/spawn-gpu-req" "$@"
}
spawn-ydu-req(){
    spawn "$HOME/scripts/spawn-ydu-requeue" "$@"
}
spawn-seas(){
    spawn "$HOME/scripts/spawn-seas" "$@"
}
spawn-h200(){
	spawn "$HOME/scripts/spawn-h200" "$@"
}
