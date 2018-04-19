#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que cria os links simbólicos dos arquivos de configuração que
# estão no Dropbox.
# Usado principalmente num computador recem formatado
# ##############################################################################

set -e

# carrega todos os dotfiles para o $HOME
for dotfile in dotfiles/.*[a-z]; do
  home_file=$(basename $dotfile)
  dotfile="$(pwd)/$dotfile"

  # se o arquivo já existir no $HOME, delete
  if [ -L ~/$home_file ];then
    rm ~/$home_file
  fi

  ln -s "$dotfile" ~/$home_file
done

# Carrega o ~/.bash_aliases no ~/.bashrc caso não tenha
#-------------------------------------------------------------------------------
load_bash_aliases='
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
'

if [ ! $(grep '\. ~/.bash_aliases' ~/.bashrc | wc -l) -ge 1 ];then
  echo "$load_bash_aliases" >> ~/.bashrc
fi;

# movendo o arquivo de credenciais para o $HOME
if [ ! -f ~/.gitconfig.local ];then
  cp .gitconfig.local.template ~/.gitconfig.local
  vim ~/.gitconfig.local
fi


# setando o wallpaper
#-------------------------------------------------------------------------------
wallpaper="$HOME/Dropbox/Images/current_wallpaper.jpg"
wallpaper_picture="$HOME/Pictures/current_wallpaper.jpg"

if [ -f "$wallpaper" ];then
  if [ ! -f "$wallpaper_picture" ];then
    ln -s "$wallpaper" "$wallpaper_picture"
    gsettings set org.gnome.desktop.background picture-uri file://${wallpaper_picture}
  fi
fi

echo "dotfiles instalados =D"
