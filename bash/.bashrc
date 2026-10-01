export PATH="$PATH:/opt/nvim/"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

short_pwd(){
   local pwd_path="$PWD"
   if [[ "$pwd_path" == "$HOME" ]]; then
	   echo "~"
	   return
   fi
   
   pwd_path="${pwd_path/#$HOME/\~}"
   local num_dirs=$(echo "$pwd_path" | tr -cd '/' | wc -c)  

   if [[ $num_dirs -le 2 ]]; then
	   echo "$pwd_path"
   else
	   echo "~/$(echo "$pwd_path" | rev | cut -d'/' -f1-2 | rev)"
   fi
}  
# Function to extract the current Git branch name
parse_git_branch() {
    echo "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')"
}

# PS1 updated with the Git branch in blue
#PS1='\[\e[1;32m\]\u@zorin\[\e[0m\]:\[\e[1;34m\]$(short_pwd)\[\e[0m\]\[\e[1;34m\]\$(parse_git_branch)\[\e[0m\]\$ '
PS1='\[\e[1;32m\]\u@zorin\[\e[0m\]:\[\e[1;34m\]$(short_pwd)\[\e[0m\]\$ '
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=none'
    alias dir='dir --color=none'
    alias vdir='vdir --color=none'

    alias grep='grep --color=none'
    alias fgrep='fgrep --color=none'
    alias egrep='egrep --color=none'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Personalization - matheusvir

alias p='python3'
alias gpp='g++ -o temp'
alias cplus='printer'
alias ibeam='echo -e "\033[6 q"'
alias att='sudo apt update && sudo apt upgrade'
alias j='java'
alias jc='javac'
alias get_token="curl http://localhost:8080/auth/login -H 'Content-Type:application/json' -d '{}'"
printer(){
  source="$1"
  shift
  ext="${source##*.}"
  for name in "$@"; do
    cp "$source" "${name}.${ext}"
  done
}

alias condaa='conda activate'
alias condad='conda deactivate'

# export PATH="/home/matheusvirgolino/miniconda3/bin:$PATH"  # commented out by conda initialize
export LS_COLORS='di=38;2;123;211;250:fi=0:ln=38;2;250;123;211:ex=38;2;123;250;123:*.tar=38;2;250;123;123:*.gz=38;2;250;123;123:*.zip=38;2;250;123;123'

# Garantir que ls use cores
alias ls='ls --color=auto'
# Alias e funções raiutu
javar(){
javac "$1" && java "$1"
}
mkcd(){
mkdir "$1" && cd "$1"
}
up() {
    local levels=$1
    
    local deep=$(echo -n "$PWD" | tr -c "/" "-" | tr -d "-" | wc -c) 
    if (( deep - 2 <= levels )) ; then
        cd ~
        return
    fi
    
    local path=""
    for ((i=0; i<levels; i++)); do 
        path+="../"
    done
    cd "$path"
}
reset_infra() {
    export KUBECONFIG=~/.kube/karmada.config
    kubectl delete deploy --all
}
restart_all(){
    reset_infra && make stop-all-containers && make run-all-containers && make start
}
alias workload_id="jq -r '.[] | select(.label == 1) | .workload_id' recomendations_aiengine*.json" 
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH="$PATH:/snap/bin"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/go/bin

# Created by `pipx` on 2026-01-16 17:26:37
export PATH="$PATH:/home/railton/.local/bin"

analyze(){
    # 1. CORREÇÃO: Definir a lista corretamente (pode ser hardcoded ou lendo de arquivo)
    analyze_round
    echo "================="
    ids=$workload_id 
    for idx in $ids; do 
        # 2. CORREÇÃO: Removido espaço após 'cluster='
        # 3. CORREÇÃO: Usado --arg para passar o ID com barra (/) de forma segura para o jq
        cluster=$(jq -r --arg id_alvo "$idx" '.[] | select(.workload_id == $id_alvo) | .cluster_label' metrics*.json)
        
        # Verificação extra: só imprime se achou algum cluster (evita linhas vazias)
        if [ ! -z "$cluster" ]; then
            echo "$idx is in $cluster"
        else
            echo "$idx not found"
        fi
    done
}
alias "d"="date"
alias vm-bd="ssh -o ServerAliveInterval=30 railtondsd@150.165.85.18 -p 45600"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/railton/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/railton/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/railton/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/railton/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

d
eval -- "$(/usr/local/bin/starship init bash --print-full-init)"
# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
export OPENCODE_ENABLE_EXA=1
# <<< oh-my-opencode-slim background subagents <<<

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/home/railton/.opencode/bin:$PATH
