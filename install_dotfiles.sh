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
create_git_credentials(){
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

install_public_dotfiles(){
  local public_dotfiles_folder="${HOME}/.public-dotfiles"

  if [ -d $public_dotfiles_folder ];then
    rm -rf $public_dotfiles_folder
  fi

  mkdir $public_dotfiles_folder

  for public_dotfiles in public-dotfiles/*; do
    local home_public_dotfiles="${public_dotfiles_folder}/$(basename $public_dotfiles)"
    local public_dotfiles="$(pwd)/${public_dotfiles}"

    ln -s "$public_dotfiles" "$home_public_dotfiles"
  done
}

install_private_dotfiles(){
  local private_dotfiles_folder="${HOME}/.private-dotfiles"

  if [ -d $private_dotfiles_folder ];then
    rm -rf $private_dotfiles_folder
  fi

  mkdir $private_dotfiles_folder

  for private_dotfiles in private-dotfiles/*; do
    local home_private_dotfiles="${private_dotfiles_folder}/$(basename $private_dotfiles)"
    local private_dotfiles="$(pwd)/${private_dotfiles}"

    ln -s "$private_dotfiles" "$home_private_dotfiles"
  done
}

# ######################### MAIN #########################
create_git_credentials
link_dotfiles
link_config_tools
# install_my_ohmyzsh_theme
install_public_dotfiles
install_private_dotfiles

echo "dotfiles instalados =D"
