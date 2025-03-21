# omz:
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
ZSH_THEME="pygmalion-virtualenv"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(zsh-syntax-highlighting zsh-autocomplete)
zstyle ':omz:update' mode auto
source $ZSH/oh-my-zsh.sh

# zsh:
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey '^X' create_completion
zle -N create_completion
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

# proxy:
alias SET_PROXY="export http_proxy=\"http://proxy.lab.tiankaima.cn:7890\" https_proxy=\$http_proxy no_proxy=\"localhost, 127.0.0.1, ::1, *.cn\""
alias UNSET_PROXY="unset http_proxy https_proxy no_proxy"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
    tmux attach-session -t main || tmux new-session -s main
fi
