#!/bin/bash

# ##############################################################################
# [Descrição]:
#
# Script que instala as ferramentas de customização de desktop.
# Instalando também os dotfiles
# ##############################################################################

install_conky(){
  sudo apt install conky-all
}

install_terminator(){
  sudo apt install terminator
}

install_albert(){
  wget -nv -O Release.key \
    https://build.opensuse.org/projects/home:manuelschneid3r/public_key
  sudo apt-key add - < Release.key
  sudo apt update
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
  sudo apt update
  sudo apt install albert
  rm Release.key
}

install_tint2(){
  sudo apt install cmake \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libglib2.0-dev \
    libimlib2-dev \
    libgtk2.0-dev \
    libxinerama-dev \
    libx11-dev \
    libxdamage-dev \
    libxcomposite-dev \
    libxrender-dev \
    libxrandr-dev \
    librsvg2-dev \
    libstartup-notification0-dev

  cd ~ > /dev/null
  git clone https://gitlab.com/o9000/tint2.git
  cd tint2 > /dev/null
  git checkout 16.6.1
  mkdir build
  cd build
  cmake ..
  make -j4

  cd ~ > /dev/null
}

sudo apt update

install_conky
install_terminator
install_albert
install_tint2

# instala os dotfiles
./install_dotfiles.sh
