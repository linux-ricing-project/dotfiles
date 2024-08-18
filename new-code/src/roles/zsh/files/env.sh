# exibindo data e hora no comando 'history'
export HISTTIMEFORMAT="%d/%m/%y %T "

source "${FZF_BASE}/key-bindings.zsh"
export FZF_DEFAULT_COMMAND='fdfind --type f --color=never'

# Show fzf in fullscreen
export FZF_DEFAULT_OPTS="--height=100% --border=rounded --reverse"

# CTRL + T: call the fzf in current folder
# with a preview by bat
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"

# ALT + C: call the fzf in current folder
# with a tree preview
export FZF_ALT_C_COMMAND="fdfind --type d . --color=never"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 50'"

# set default editor to vim
export EDITOR=vim

# variáveis para colorir manpages
export LESS_TERMCAP_mb=${bold_green}
export LESS_TERMCAP_md=${bold_green}
export LESS_TERMCAP_me=${text_reset}
export LESS_TERMCAP_se=${text_reset}
export LESS_TERMCAP_so=${bold_yellow}
export LESS_TERMCAP_ue=${text_reset}
export LESS_TERMCAP_us=${bold_red}

