#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala os dotfiles, comandos, e configs através de links simbólicos
# ##############################################################################

set -e

# carrega todos os dotfiles para o $HOME
link_dotfiles(){
  # linkando os arquivos
  for dotfile in dotfiles/.*[a-z]; do
    local home_dotfile=$(basename $dotfile)
    dotfile="$(pwd)/$dotfile"

    # se o arquivo já existir no $HOME, delete
    if [ -e ~/$home_dotfile ] ||\
       [ -f ~/$home_dotfile ] ||\
       [ -L ~/$home_dotfile ];then
        rm -rf ~/$home_dotfile
    fi

    ln -s "$dotfile" ~/$home_dotfile
  done
}

# linkando os arquivos de configuração
link_config_tools(){
  for config in config/*; do
    local home_config="$HOME/.config/$(basename $config)"
    config="$(pwd)/$config"

    # se o arquivo já existir no $HOME, delete
    if [ -e "$home_config" ] ||\
       [ -d "$home_config" ] ||\
       [ -L "$home_config" ];then
        rm -rf "$home_config"
    fi

    ln -s "$config" "$home_config"
  done
}

# carregando o frankrc
link_frankrc(){
  local load_frankrc='
  # carregando minhas configs (alias, functions...)
  test -f ~/.frankrc && . ~/.frankrc
  '

  if ! grep -q "~/.frankrc" ~/.bashrc ;then
    echo "$load_frankrc" >> ~/.bashrc
  fi
}

# movendo o arquivo de credenciais para o $HOME
link_git_config(){
  if [ ! -f ~/.gitconfig.local ];then
    cp .gitconfig.local.template ~/.gitconfig.local
    vim ~/.gitconfig.local
  fi
}

# criando uma chave genérica de SSH, pra ser executado a primeira vez
create_ssh_key(){
  if [ ! -f ~/.ssh/id_rsa.pub ];then
    # -q --> is silent
    # -t rsa --> generate key
    # -N '' --> tells to use empty passphrase
    # -f <file> --> the file with new key
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa > /dev/null
  fi
}


link_dotfiles
link_frankrc
link_config_tools
link_git_config
create_ssh_key

echo "dotfiles instalados =D"
