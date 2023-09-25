#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala os dotfiles, comandos, e configs através de links simbólicos
# ##############################################################################

set -e

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

    echo "[OK] ${HOME}/$home_dotfile created"
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

    echo "[OK] $home_config created"
  done
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

    echo "[OK] $home_public_dotfiles created"
  done
}

install_private_dotfiles(){
  local private_dotfiles_folder="${HOME}/.private-dotfiles"

    # check if folder in this project exist.
    # If don't exist, is the because is temporarily dotfiles
    if [ -d private-dotfiles/ ];then

        if [ -d $private_dotfiles_folder ];then
            rm -rf $private_dotfiles_folder
        fi

        mkdir $private_dotfiles_folder

        for private_dotfiles in private-dotfiles/*; do
            local home_private_dotfiles="${private_dotfiles_folder}/$(basename $private_dotfiles)"
            local private_dotfiles="$(pwd)/${private_dotfiles}"

            ln -s "$private_dotfiles" "$home_private_dotfiles"
            echo "[OK] $home_private_dotfiles created"

        done

    fi
}

install_autostart_commands(){
  for autostart in autostart/*; do
    local home_autostart="${HOME}/.config/${autostart}"
    autostart="$(pwd)/${autostart}"

    # se o arquivo já existir no $HOME/.config/autostart, delete
    if [ -e "$home_autostart" ] ||\
       [ -f "$home_autostart" ] ||\
       [ -L "$home_autostart" ];then
        rm -rf "$home_autostart"
    fi


    ln -s "$autostart" "$home_autostart"
    echo "[OK] $home_autostart created"
  done
}

# ######################### MAIN #########################
install_autostart_commands
link_dotfiles
link_config_tools
install_public_dotfiles
install_private_dotfiles