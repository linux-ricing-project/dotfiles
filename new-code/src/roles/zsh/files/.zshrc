
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    zsh-syntax-highlighting
    zsh-completions
    # zsh-autosuggestions
    )


if [ -d ${HOME}/.config/dotfiles ]; then
   for public_files in ${HOME}/.config/dotfiles/*; do
      source $public_files
   done
fi

# if [ -d ${HOME}/.public-dotfiles/ ]; then
#    for public_files in ${HOME}/.public-dotfiles/*; do
#       source $public_files
#    done
# fi

# if [ -d ${HOME}/.private-dotfiles/ ]; then
#    for private_files in ${HOME}/.private-dotfiles/*; do
#       source $private_files
#    done
# else
#    test -f "$HOME/Dropbox/check_dotfiles.sh" && bash "$HOME/Dropbox/check_dotfiles.sh" || return 0
# fi


# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~

# exibindo data e hora no comando 'history'
export HISTTIMEFORMAT="%d/%m/%y %T "
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE  # Don't save when prefixed with space
setopt HIST_IGNORE_DUPS   # Don't save duplicate lines
setopt SHARE_HISTORY      # Share history between sessions

if [ -f "${FZF_BASE}/key-bindings.zsh" ];then
  source "${FZF_BASE}/key-bindings.zsh"
fi
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

export TERM="tmux-256color"

# variáveis para colorir manpages
export LESS_TERMCAP_mb=${bold_green}
export LESS_TERMCAP_md=${bold_green}
export LESS_TERMCAP_me=${text_reset}
export LESS_TERMCAP_se=${text_reset}
export LESS_TERMCAP_so=${bold_yellow}
export LESS_TERMCAP_ue=${text_reset}
export LESS_TERMCAP_us=${bold_red}

if [ -f "${HOME}/.atuin/bin/env" ];then
  source "${HOME}/.atuin/bin/env"
fi
if which atuin > /dev/null 2>&1 ;then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

if which zoxide > /dev/null 2>&1 ;then
  eval "$(zoxide init zsh)"
fi

export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# ~~~~~~~~~~~~~~~ Paths ~~~~~~~~~~~~~~~~~~~~~~~~
path=(
    $path               # Keep existing PATH entries
    $HOME/.bin/
    $HOME/.local/bin
    $HOME/.krew/bin
)

# Remove duplicate entries and non-existent directories
typeset -U path

# TODO: Precisa mesmo dessa linha?
export PATH