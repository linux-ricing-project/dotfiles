#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala os dotfiles, comandos, e configs através de links simbólicos
# ##############################################################################

set -e

git_nome="$1"
git_email="$2"

# ============================================
# movendo o arquivo de credenciais para o $HOME
# ============================================
create_git_credetials(){
  if [ ! -f ~/.gitconfig.local ];then
    if [ -z "$git_email" ] || [ -z "$git_nome" ];then
      echo "Arquivo do ~/.gitconfig.local não existe"
      echo "passe o nome e o email por parametro pro script"
      echo "ex: ./install_dotfiles.sh <NOME> <EMAIL>"
      exit 1
    else
      cp .gitconfig.local.template ~/.gitconfig.local
      sed -i "s/@nome@/$git_nome/g" ~/.gitconfig.local
      sed -i "s/@email@/$git_email/g" ~/.gitconfig.local
    fi
  fi
}

# ============================================
# carrega todos os dotfiles para o $HOME
# ============================================
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

# ============================================
# linkando os arquivos de configuração
# ============================================
link_config_tools(){
  for config in config/*; do
    local home_config="$HOME/.config/$(basename $config)"
    config="$(pwd)/${config}"

    # se o arquivo já existir no $HOME, delete
    if [ -e "$home_config" ] ||\
       [ -d "$home_config" ] ||\
       [ -L "$home_config" ];then
        rm -rf "$home_config"
    fi

    ln -s "$config" "$home_config"
  done
}

# ============================================
# carregando o frankrc
# ============================================
link_frankrc(){
  local load_frankrc='
  # carregando minhas configs (alias, functions...)
  test -f ~/.frankrc && . ~/.frankrc
  '

  if ! grep -q "~/.frankrc" ~/.bashrc ;then
    echo "$load_frankrc" >> ~/.bashrc
  fi
}

# ============================================
# criando uma chave genérica de SSH, pra ser executado a primeira vez
# ============================================
create_ssh_key(){
  if [ ! -f ~/.ssh/id_rsa.pub ];then
    # -q --> is silent
    # -t rsa --> generate key
    # -N '' --> tells to use empty passphrase
    # -f <file> --> the file with new key
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa > /dev/null
  fi
}

# ============================================
# Instala um 'theme' customizado pro Alfred, usando
# a paleta de cores do 'Nord'
#
# color-pallete: https://www.nordtheme.com/
# Albert Theme Creator: https://albertlauncher.github.io/docs/extensions/widgetboxmodel/themecreator/
# ============================================
install_albert_theme(){
  # criando a pasta de 'theme' caso não exista
  local albert_themes_folder="/usr/share/albert/org.albert.frontend.widgetboxmodel/themes"
  [[ ! -d "$albert_themes_folder" ]] && mkdir -p "$albert_themes_folder"

  local file_dest="${albert_themes_folder}/Nord.qss"
  # se o arquivo já existir no destino, delete
  if [ -e "$file_dest" ] ||\
     [ -L "$file_dest" ];then
      rm -rf "$file_dest"
  fi

  # copiando o tema pra lá.
  sudo ln -s "$(pwd)/files/Nord.qss" "$file_dest"
  sudo chmod 644 "$file_dest"
}

# ============================================
# Instala meu próprio tema do 'Oh-My-Zsh'.
# OBS: Ainda em fase beta
# ============================================
install_my_ohmyzsh_theme(){
  local file_dest="${HOME}/.oh-my-zsh/themes/frank.zsh-theme"

  # se o arquivo já existir no destino, delete
  if [ -e "$file_dest" ] ||\
     [ -L "$file_dest" ];then
      rm -rf "$file_dest"
  fi

  # copiando o tema pra lá.
  ln -s "files/frank.zsh-theme" "$file_dest"
}

# ######################### MAIN #########################
create_git_credetials
link_dotfiles
link_frankrc
link_config_tools
create_ssh_key
install_albert_theme
install_my_ohmyzsh_theme

echo "dotfiles instalados =D"
