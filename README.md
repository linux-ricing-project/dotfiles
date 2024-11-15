<img alt="Icon" src="https://dotfiles.github.io/images/dotfiles-logo.png?raw=true" align="middle" height="114" width="400">

![](https://img.shields.io/badge/-Linux-000000.svg?style=for-the-badge&logo=Linux&logoColor=white)
![](https://img.shields.io/badge/-ubuntu_24.04-2C001E.svg?style=for-the-badge&logo=ubuntu&logoColor=white)
![](https://img.shields.io/badge/-ZSH-3E2723.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

# Dotfiles

##### Inspired from `dotfiles` of [TechDufus](https://github.com/techdufus/dotfiles)

My dotfiles, for personal use.


# Install

## Default installation
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/linux-ricing-project/dotfiles/refs/heads/master/bin/dotfiles)"
```

## Customize Installation
```shell
git clone git@github.com:linux-ricing-project/dotfiles.git

# Open and Edit the file "src/group_vars/all.yaml"
# comment or uncomment the roles list, and after run, with this command:
cd bin
./dotfiles
```

