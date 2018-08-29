#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala os dotfiles, comandos, e configs através de links simbólicos
# ##############################################################################

set -e

set_wallpaper(){
  wallpaper="$HOME/Dropbox/Images/current_wallpaper.jpg"
  wallpaper_picture="$HOME/Pictures/current_wallpaper.jpg"

  if [ -f "$wallpaper" ];then
    if [ ! -f "$wallpaper_picture" ];then
      ln -s "$wallpaper" "$wallpaper_picture"
      gsettings set org.gnome.desktop.background picture-uri file://${wallpaper_picture}
    fi
  fi
}

# linkando os binários
link_bin(){
  test -d $HOME/bin || ln -s $(pwd)/bin $HOME/bin
  chmod +x $HOME/bin/*
}

# carrega todos os dotfiles para o $HOME
link_dotfiles(){
  # linkando os arquivos
  for dotfile in dotfiles/.*[a-z]; do
    home_file=$(basename $dotfile)
    dotfile="$(pwd)/$dotfile"

    # se o arquivo já existir no $HOME, delete
    if [ -L ~/$home_file ];then
      rm ~/$home_file
    fi

    ln -s "$dotfile" ~/$home_file
  done
}

# linkando os arquivos de configuração
link_config_tools(){
  for config in config/*; do
    home_file=$HOME/.config/$(basename $config)
    config="$(pwd)/$config"

    # se o arquivo já existir no $HOME, delete
    if [ -d "$home_file" ];then
      rm -rf "$home_file"
    fi

    ln -s "$config" "$home_file"
  done
}

# carregando o frank_bash
link_frank_bash(){
  local load_frank_bash='
  # carregando minhas configs (alias, functions...)
  test -f ~/.frank_bash && . ~/.frank_bash
  '

  if [ ! $(grep '\. ~/.frank_bash' ~/.bashrc | wc -l) -ge 1 ];then
    echo "$load_frank_bash" >> ~/.bashrc
  fi;
}

# movendo o arquivo de credenciais para o $HOME
link_git_config(){
  if [ ! -f ~/.gitconfig.local ];then
    cp .gitconfig.local.template ~/.gitconfig.local
    vim ~/.gitconfig.local
  fi
}


link_bin
link_dotfiles
link_frank_bash
link_config_tools
# set_wallpaper

echo "dotfiles instalados =D"
