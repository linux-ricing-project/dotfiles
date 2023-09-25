# seta o layout do teclado para teclados BR-ABNT2
#setxkbmap -layout br

# Seta o layout do teclado para usar o "Logitech Mx Keys"
setxkbmap -model logitech_base -layout us -variant intl -option "compose:ralt"

################################################################################
#  LINUX COMMANDS ALIASES
################################################################################

# se o 'colorls' estiver instalado, sobrescreva o 'ls' pra usar o 'colorls'
if type colorls > /dev/null 2>&1; then
    source $(dirname $(gem which colorls))/tab_complete.sh
    # ls sobrescrito para usar o 'colorls' (caso esteja instalado)
    # --sd --> folders first
    # -A --> 'Almost All'. List without '.' and '..'
    alias ls='colorls --sd'
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

# alias de navegação
alias ..="cd .."
alias cd..="cd .."
alias back="cd -"

# alias pro 'free'
# -m  - memória
# -t  - exibe uma linha a mais com o total de memória
# -h  - leitura mais humana
alias free="free -mth"

# print 'ls -lha' com formato de timestamp
alias ll='ls -l --time-style=+"%d-%m-%Y %H:%M:%S" --color -h -a'

# get folder size
alias size='du -sh'

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
function showMyAlias(){
    my_alias="$1"

    # validação
    if [ -z "$my_alias" ];then
        echo "Digite um alias ou function no 1º paramêtro"
        return 0
    fi

    # verifique se é um alias
    if type "$my_alias" | grep -q "is an alias"; then
        echo "[alias]:"
        type "$my_alias" | cut -d " " -f6-
    # verifique se é uma function
    elif type "$my_alias" | grep -q "is a shell function"; then
        echo "[function]:"
        declare -f "$my_alias"
    else
        echo "alias ou function não encontrado"
        return 1
    fi
}



################################################################################
#  FILE MANAGER ALIASES
################################################################################

# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# Find files and exec commands at them.
# $ find-exec .coffee cat | wc -l
# # => 9762
function find-exec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Alias para criar um novo diretório e entrar nele, logo na sequencia
function new_folder(){
  test -z $1 && echo "passe o nome do novo diretorio por parametro" && return 1
  mkdir -p "$@" && cd "$@"
}

# Função usada para converter a diferença de "line ending"
# entre Windows (CRLF) e Linux (LF). Pra não ter que usar um
# pacote externo (dos2unix), preferi usar o sed.
# ele converte o "line-ending" do Windows ('\r') para o Linux.
# uso: chame o alias passando um arquivod e texto por parametro.
function winToLinux(){
    local file=$1

    test -z "$file" && echo "passe um arquivo por parametro" && return 1
    test ! -f "$file" && echo "passe um arquivo válido" && return 1

    sed -i 's/\r$//' "$file"
}

# limpa a lixeira
function limpar_lixeira(){
    print_info "Limpando lixeira...."
    rm -rfv  ~/.local/share/Trash/*
    print_info "Lixeira vazia!"
}

# cria rapidamente um script novo
function fast_script(){
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
function arquivo() {
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
function refresh_shell(){
    local shell_file=""

    if grep "$USER" "/etc/passwd" | grep -q bash ;then
      shell_file="${HOME}/.bashrc"
    elif grep "$USER" "/etc/passwd" | grep -q zsh ;then
      shell_file="${HOME}/.zshrc"
    fi

    source "$shell_file" > /dev/null && echo "shell refreshed"
}

  # alias pra trocar de shell padrão bash --> zsh
function bashToZsh(){
  if type zsh > /dev/null 2>&1 ;then
    chsh -s $(which zsh)
  fi
}

  # alias pra trocar de shell padrão zsh --> bash
function zshToBash(){
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
function apt-get_fix(){
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
function atualizar_computador(){
  print_info "Update..."
  sudo apt update

  print_info "Upgrade..."
  sudo apt upgrade -y
  sudo apt dist-upgrade -y

  print_info "Resolvendo pacotes quebrados..."
  sudo apt -f -y install

  print_info "limpando o repositório local..."
  sudo apt autoremove -y
  sudo apt autoclean -y
  sudo apt clean -y
}

# Mostra todas as interfaces de rede, highlighted, e de mais fácil visualização.
alias ips='ip -c -br a'