#!/bin/bash
# seta o layout do teclado para teclados BR-ABNT2
#setxkbmap -layout br

# Seta o layout do teclado para usar o "Logitech Mx Keys"
# setxkbmap -model logitech_base -layout us -variant intl -option "compose:ralt"

if [ -f "${HOME}/.atuin/bin/env" ];then
  source "${HOME}/.atuin/bin/env"
fi
if which atuin > /dev/null 2>&1 ;then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

################################################################################
#  OVERRIDE LINUX COMMANDS
################################################################################

################# LS
# se o 'lsd' estiver instalado, sobrescreva o 'ls' pra usar o 'lsd'
if type lsd > /dev/null 2>&1; then
    alias ls='lsd'
else
    # ls padrão com cores automáticas
    alias ls='ls -h --color=auto --group-directories-first'
    # grep padrão com cores automáticas
    alias grep='grep --color=auto'
    # fgrep padrão com cores automáticas
    alias fgrep='fgrep --color=auto'
    # egrep padrão com cores automáticas
    alias egrep='egrep --color=auto'
fi

alias cat='bat'
alias cd='z'
cx(){ cd "$@" && ls; }

# fd = package to replace "find" command
# package used by "fzf" in "FZF_DEFAULT_COMMAND" env variable
# Installation Ubuntu: sudo apt install fd-find
# The name of executable is "fdfind". So, only in Ubuntu is necessary this alias below
alias fd='fdfind'

# alias de navegação
alias ..="cd .."
alias cd..="cd .."

alias ...="cd ../.."
alias .2="cd ../.."

alias ....="cd ../../.."
alias .3="cd ../.."

alias .....="cd ../../../.."
alias .4="cd ../.."

alias back="cd -"

# alias pro 'free'
# -m  - memória
# -t  - exibe uma linha a mais com o total de memória
# -h  - leitura mais humana
alias free="free -mth"

# get and print folder size for all folders, recursively
alias sizer='du -h -c'



################################################################################
#  ALIAS AND FUNCTIONS ALIASES
################################################################################
# lista os alias de forma mais amigável
alias aliases="alias | sed 's/=.*//'"

# lista todas as funções de forma mais amigável
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

# print $path mais amigável
alias path='echo $PATH | tr ":" "\n" | sort'

# funcção que imrpime o conteúdo de um alias ou função no terminal.
show_my_alias(){
    my_alias=$(echo "$1" | sed 's/()//g' | sed 's/alias //g')

    # validação
    if [ -z "$my_alias" ];then
        echo "Digite um alias ou function no 1º paramêtro"
        return 0

    fi

    # verifique se é um alias
    if type "$my_alias" | grep -q "is an alias"; then
        type "$my_alias" | cut -d " " -f6- | bat --color=always -l bash --file-name="alias"
    # verifique se é uma function
    elif type "$my_alias" | grep -q "is a shell function"; then
        declare -f "$my_alias" | bat --color=always -l bash --file-name="function"
    else
        echo "alias ou function não encontrado"
        return 1
    fi
}

list_my_alias(){
  local dotfiles_path="${HOME}/Dropbox/code/01.github/linux_ricing_project/dotfiles"
  local public_dotfiles_path="${dotfiles_path}/public-dotfiles"
  local private_dotfiles_path="${dotfiles_path}/private-dotfiles"

  local search_query='^alias [a-zA-Z_][a-zA-Z0-9_]*='

  grep -rE "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* > /tmp/list_alias.tmp

  show_my_alias "$(grep --no-filename -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* | \
   cut -d "=" -f1 |\
    fzf  --header-first --header="Alias" --layout reverse --preview '
      file=$(grep {} /tmp/list_alias.tmp | cut -d ":" -f 1);
      alias_line={}

      grep {} "$file" | cut -d "=" -f2
    ')"

    rm -rf /tmp/list_alias.tmp
}


list_my_functions(){
  local dotfiles_path="${HOME}/Dropbox/code/01.github/linux_ricing_project/dotfiles"
  local public_dotfiles_path="${dotfiles_path}/public-dotfiles"
  local private_dotfiles_path="${dotfiles_path}/private-dotfiles"

  local search_query='^(function )?[a-zA-Z_][a-zA-Z0-9_]*\(\)'

  grep -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* > /tmp/list_functions.tmp

  show_my_alias "$(grep --no-filename -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* | \
   sed "s/function //g" | sed "s/{//g" |\
    fzf  --header-first --header="Functions" --layout reverse --preview '
      file=$(grep {} /tmp/list_functions.tmp | cut -d ":" -f 1);
      function_line={}
      awk "/^${function_line}/,/^\}/ { if (/^\}/ && getline == 0) exit; print NR, \$0 }" "$file"
')"

  rm -rf /tmp/list_functions.tmp
}



################################################################################
#  FILE MANAGER ALIASES
################################################################################

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# Find files and exec commands at them.
# $ find-exec .coffee cat | wc -l
# # => 9762
find-exec(){
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Alias para criar um novo diretório e entrar nele, logo na sequencia
new_folder(){
  test -z $1 && echo "passe o nome do novo diretorio por parametro" && return 1
  mkdir -p "$@" && cd "$@"
}

# Função usada para converter a diferença de "line ending"
# entre Windows (CRLF) e Linux (LF). Pra não ter que usar um
# pacote externo (dos2unix), preferi usar o sed.
# ele converte o "line-ending" do Windows ('\r') para o Linux.
# uso: chame o alias passando um arquivod e texto por parametro.
winToLinux(){
    local file=$1

    test -z "$file" && echo "passe um arquivo por parametro" && return 1
    test ! -f "$file" && echo "passe um arquivo válido" && return 1

    sed -i 's/\r$//' "$file"
}

# limpa a lixeira
limpar_lixeira(){
    echo "Limpando lixeira...."
    rm -rfv  ~/.local/share/Trash/*
    echo "Lixeira vazia!"
}

# cria rapidamente um script novo
fast_script(){
  local filename="$1"
  if [ -z "$filename" ];then
    echo "digite o nome do script"
    return 1
  fi

  echo '#!/bin/bash' > "${filename}.sh"
  chmod +x "${filename}.sh"
  code -n "${filename}.sh"
}

# Ref: https://github.com/SeraphyBR/DotFiles/blob/master/.zshrc
# alias para ler um arquivo ou acessar um diretório.
# OBS: o comando "bat" não vem instalado por padrão.
arquivo(){
  local parametro="$1"
  local file_type=$(file -i "$parametro" | awk '{print $2}' | grep "text")
  if [ $# -eq 0 ];then
      clear
  elif [ -d "$parametro" ];then
      cd "$parametro"
  elif [ ! -z "$file_type" ];then
    bat "$parametro"
  fi
}

# remove todos os screenshots salvos
alias remove_all_screenshots="find ${HOME}/Pictures -type f -iname \"Screenshot*.png\" -delete"


################################################################################
#  SHELL ALIASES
################################################################################
 # alias pra recarregar o shell
refresh_shell(){
    local shell_file=""

    if grep "$USER" "/etc/passwd" | grep -q bash ;then
      shell_file="${HOME}/.bashrc"
    elif grep "$USER" "/etc/passwd" | grep -q zsh ;then
      shell_file="${HOME}/.zshrc"
    fi

    source "$shell_file" > /dev/null && echo "shell refreshed"
}

  # alias pra trocar de shell padrão bash --> zsh
bashToZsh(){
  if type zsh > /dev/null 2>&1 ;then
    chsh -s $(which zsh)
  fi
}

  # alias pra trocar de shell padrão zsh --> bash
zshToBash(){
  if type bash > /dev/null 2>&1 ;then
    chsh -s $(which bash)
  fi
 }

################################################################################
#  APT-GET ALIASES
################################################################################

# Função pra deletar os lock do apt-get.
# Usado principalmente, quando ele trava do nada.
# Além de reconfigurar o dpkg e resolver os pacotes quebrados
apt_get_fix(){
  test -f /var/lib/apt/lists/lock && sudo rm -rf /var/lib/apt/lists/lock
  test -f /var/cache/apt/archives/lock && sudo rm -rf /var/cache/apt/archives/lock
  test -f /var/lib/dpkg/lock && sudo rm -rf /var/lib/dpkg/lock
  test -f /var/lib/dpkg/lock-frontend && sudo rm -rf /var/lib/dpkg/lock-frontend

  sudo apt --fix-broken install
  sudo dpkg --configure -a
  echo "OK"
}

# atualiza o computador e limpa os pacotes .deb
# lá de '/var/cache/apt/archives/'
upgrade(){
  echo "Update..."
  sudo apt update

  echo "Upgrade..."
  sudo apt upgrade -y
  sudo apt dist-upgrade -y

  echo "Resolvendo pacotes quebrados..."
  sudo apt -f -y install

  echo "limpando o repositório local..."
  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt clean -y
}

# Mostra todas as interfaces de rede, highlighted, e de mais fácil visualização.
alias ips='ip -c -br a'