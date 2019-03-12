<img alt="Icon" src="https://dotfiles.github.io/images/dotfiles-logo.png?raw=true" align="middle" height="114" width="400">

# dotfiles

##### Inspired from `dotfiles` of [Aurélio Jargas](https://github.com/aureliojargas/dotfiles)

![dependence](https://img.shields.io/badge/linux-ubuntu_18.04-212121.svg?style=true)

My config files.
The script `install_dotfiles.sh` create symbolic links in the `$HOME` with the files.
After that run the script, reload yout `~/.bashrc` with `source ~/.bashrc`

# Install
```shell
git clone git@github.com:frankjuniorr/dotfiles.git
cd dotfiles
./install_dotfiles.sh
source ~/.bashrc
```

# Files

## albert

> albert.conf

[Albert](https://github.com/albertlauncher/albert) file configuration, with my personal preferences. The installer script, link this file into `$HOME/.config`

## atom

> config.cson

[Atom](https://atom.io/) file configuration, with my personal preferences. The installer script, link this file into `$HOME/.atom/config.cson`

## config

Directory that have all config files, linking to `$HOME/.config`

> conky

Configuration file of all [conkys](https://github.com/brndnmtthws/conky)

> terminator

configutarion file with may profile preferencesof terminal [Terminator](https://launchpad.net/terminator)

> tint2

Configuration file of all [tint2](https://gitlab.com/o9000/tint2) bars

## dotfiles

Directory that have my all dotfiles. All files in this directory is link into `$HOME`

> .colors.sh

Auxiliar file with many colors variables, used to colorized messages

> .frankrc

My principal dotfile, in this file i have my functions, alias e some other preferences

> .git_diff_meld.py

Auxiliar python code, to open Meld in git diffs

> .git_prompt

File with my prompt (PS1) personalized, with git features (see Demo)

> .gitconfig

My global git configurations

> .inputrc

My input configuration, like tab-completions ignoring case

> .tmux.conf

Configuration file of [Tmux](https://github.com/tmux/tmux/wiki)

> .vimrc

Configuration file of Vim

## Prompt demo

<img alt="Icon" src="screenshots/prompt_example.png?raw=true" align="center" hspace="1" vspace="1">

## Prompt demo with git conflicts

<img alt="Icon" src="screenshots/conflict_example.png?raw=true" align="center" hspace="1" vspace="1">
