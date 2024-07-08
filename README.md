<img alt="Icon" src="https://dotfiles.github.io/images/dotfiles-logo.png?raw=true" align="middle" height="114" width="400">

![](https://img.shields.io/badge/-Linux-000000.svg?style=for-the-badge&logo=Linux&logoColor=white)
![](https://img.shields.io/badge/-ubuntu_22.04-2C001E.svg?style=for-the-badge&logo=ubuntu&logoColor=white)
![](https://img.shields.io/badge/-KDE-212121.svg?style=for-the-badge&logo=kde&logoColor=white)
![](https://img.shields.io/badge/-ZSH-3E2723.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![](https://img.shields.io/badge/-Vim-004D40.svg?style=for-the-badge&logo=vim&logoColor=white)

# dotfiles

##### Inspired from `dotfiles` of [Aurélio Jargas](https://github.com/aureliojargas/dotfiles)

My config files, for personal use.

The script `install_dotfiles.sh` create symbolic links of files:
- All files inside [dotfiles](https://github.com/linux-ricing-project/dotfiles/tree/custom-shell/dotfiles) folder go to `$HOME`
- All files inside [config](https://github.com/linux-ricing-project/dotfiles/tree/custom-shell/config) folder go to `${HOME}/.config`.
- All files inside [public-dotfiles](https://github.com/linux-ricing-project/dotfiles/tree/master/public-dotfiles) folder go to `${HOME}/.public-dotfiles`

After that run the script, reload your terminal, close it and open it again.

> OBS: To choose which shell to use, use the alias: `bashTozsh` or `zshTobash`, and reload terminal

# Install
```shell
git clone git@github.com:frankjuniorr/dotfiles.git
cd dotfiles
./install_dotfiles.sh
```

## [current terminal] Terminal example (zsh)

- [Terminator](https://terminator-gtk3.readthedocs.io/en/latest/#)
- [neofetch](https://github.com/dylanaraps/neofetch)
- zsh
- [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Fira Code font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)
- [lsd](https://github.com/lsd-rs/lsd)

<img alt="Icon" src="screenshots/terminal_example.png?raw=true" align="center" hspace="1" vspace="1">
<img alt="Icon" src="screenshots/terminal_example2.png?raw=true" align="center" hspace="1" vspace="1">

## Terminal example (bash)

<img alt="Icon" src="screenshots/prompt_example.png?raw=true" align="center" hspace="1" vspace="1">

## Terminal example with git conflicts [bash]

<img alt="Icon" src="screenshots/conflict_example.png?raw=true" align="center" hspace="1" vspace="1">


