#!/bin/bash

# funcção que imrpime o conteúdo de um alias ou função no terminal.
show_my_alias(){
    my_alias=$(echo "$1" | sed 's/()//g' | sed 's/alias //g')

    # validação
    if [ -z "$my_alias" ];then
        echo "Digite um alias ou function no 1º paramêtro"
        return 0

    fi

    # verifique se é um alias
    if type "$my_alias" | grep -q "is an alias"; then
        type "$my_alias" | cut -d " " -f6- | bat --color=always -l bash --file-name="alias"
    # verifique se é uma function
    elif type "$my_alias" | grep -q "is a shell function"; then
        declare -f "$my_alias" | bat --color=always -l bash --file-name="function"
    else
        echo "alias ou function não encontrado"
        return 1
    fi
}

list_my_alias(){
  local dotfiles_path="${HOME}/Dropbox/code/01.github/linux_ricing_project/dotfiles"
  local public_dotfiles_path="${dotfiles_path}/public-dotfiles"
  local private_dotfiles_path="${dotfiles_path}/private-dotfiles"

  local search_query='^alias [a-zA-Z_][a-zA-Z0-9_]*='

  grep -rE "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* > /tmp/list_alias.tmp

  show_my_alias "$(grep --no-filename -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* | \
   cut -d "=" -f1 |\
    fzf  --header-first --header="Alias" --layout reverse --preview '
      file=$(grep {} /tmp/list_alias.tmp | cut -d ":" -f 1);
      alias_line={}

      grep {} "$file" | cut -d "=" -f2
    ')"

    rm -rf /tmp/list_alias.tmp
}


list_my_functions(){
  local dotfiles_path="${HOME}/Dropbox/code/01.github/linux_ricing_project/dotfiles"
  local public_dotfiles_path="${dotfiles_path}/public-dotfiles"
  local private_dotfiles_path="${dotfiles_path}/private-dotfiles"

  local search_query='^(function )?[a-zA-Z_][a-zA-Z0-9_]*\(\)'

  grep -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* > /tmp/list_functions.tmp

  show_my_alias "$(grep --no-filename -E "$search_query" "${public_dotfiles_path}"/* "${private_dotfiles_path}"/* | \
   sed "s/function //g" | sed "s/{//g" |\
    fzf  --header-first --header="Functions" --layout reverse --preview '
      file=$(grep {} /tmp/list_functions.tmp | cut -d ":" -f 1);
      function_line={}
      awk "/^${function_line}/,/^\}/ { if (/^\}/ && getline == 0) exit; print NR, \$0 }" "$file"
')"

  rm -rf /tmp/list_functions.tmp
}

trash_clean(){
    echo "Limpando lixeira...."
    if [ -d "${HOME}/.local/share/Trash" ];then
      rm -rfv  ~/.local/share/Trash/*
    else
      echo "This folder ${HOME}/.local/share/Trash doens't exists"
    fi
    echo "Lixeira vazia!"
}

 # alias pra recarregar o shell
refresh_shell(){
    local shell_file=""

    if grep "$USER" "/etc/passwd" | grep -q bash ;then
      shell_file="${HOME}/.bashrc"
    elif grep "$USER" "/etc/passwd" | grep -q zsh ;then
      shell_file="${HOME}/.zshrc"
    fi

    source "$shell_file" > /dev/null && echo "shell refreshed"
}

#################################################################
# TMUX Functions
#################################################################
tstart(){
    tmux start && tmux a -t "$(tmux ls -F "#{session_name}" | fzf --height 40% --prompt="Select a tmux session: ")"
}

projects(){
  project_list=($(tmuxinator list | sed -n '2p' | sed 's/ \+/ /g'))

  selected_project=$(printf "%s\n" "${project_list[@]}" | grep -v "generic" |
      fzf --header-first --header="Projects" --height=30%
  )

  # Verifica se um projeto foi selecionado
  if [ -n "$selected_project" ]; then
    # Inicia o projeto selecionado
    tmuxinator start "$selected_project"
  else
    echo "Nenhum projeto selecionado."
    return 0
  fi
}

tnew_session(){
    local session_name="$1"
    if [ -z "$session_name"  ];then
        session_name="dev"
    fi

    tmux new -s "$session_name" -n "dev"
}

tdelete_session(){
    local session_name="$1"
    if [ -z "$session_name"  ];then
        echo "Type a name of session what you want to delete"
        return 1
    fi

    tmux kill-session -t "$session_name"
}

#################################################################
# Docker Functions
#################################################################
# função auxiliar que destrói todo o ambiente docker na máquina
docker_destroy_all(){
  yes | docker system prune -a
  yes | docker volume prune
}

# Docker PS formatted to print only my most used fields
dps(){
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}"
}

#################################################################
# Git Functions
#################################################################
# alias rápido para commitar e dar git push ao mesmo tempo
git_commit_push(){
  local commit_msg=$1

  if git rev-parse --is-inside-work-tree > /dev/null;then
      if [ -n "$commit_msg" ];then
          local current_branch=$(git branch | grep "^*" | awk '{print $2}')

          git commit -a -m "$commit_msg"

          git pull
          git push origin "$current_branch"

      else
          echo "digite a mensagem do commit"
          return 1
      fi
  else
      echo "ERROR: This folder is not a git repository"
      return 1
  fi
}

# Função para adicionar as modificações no ultimo commit do log
git_edit_last_commit(){
    if git rev-parse --is-inside-work-tree > /dev/null;then
        current_branch=$(git branch | grep "^*" | awk '{print $2}')
        git commit -a --amend --no-edit
        git push origin +${current_branch}
    else
        echo "ERROR: This folder is not a git repository"
        return 1
    fi
}

  # Função que troca de branch rapidamente
git_change_branch(){
  local new_branch="$1"

  local default_branch=$(git remote show $(git remote) | sed -n '/HEAD branch/s/.*: //p')

  git checkout "$default_branch"
  git pull

  if [ -n "$new_branch" ];then
    git checkout "$new_branch"
  fi
 }

# Função pra juntar vários commits em 1 só.
# passando a quantidade por parâmetro, tipo assim:
# git_squash_commits 5 # ele irá considerar os ultimos 5 commits para fazer um squash
git_squash_commits(){
  local amount_commits="$1"

  if [ -n "$amount_commits" ];then
    current_branch=$(git branch | grep "^*" | awk '{print $2}')
    git rebase -i HEAD~$amount_commits
    git push origin +${current_branch}
  else
    echo "type the amount of commits"
    return 1
  fi
}

# Função para juntar vários commits em 1 só.
# Ele a quantidade de vezes que o ultimo commit repetiu a mensagem.
git_squash_equal_commits(){
  local last_repeated_commit_count
  last_repeated_commit_count=$(git log --format=%s -n 20 | uniq -c | head -n 1 | awk '{print $1}')

  echo current_branch="$(git branch --show-current)"
  echo "$last_repeated_commit_count"

  git rebase -i HEAD~"${last_repeated_commit_count}"
  git push origin +"${current_branch}"
}

# remove all untracked files, is case of you want to clean in repo.
git_remove_untracked_files(){
  rm -rf $(git ls-files --others --exclude-standard | xargs)
}

  # Função que cria uma nova branch local, a partir deu uma tag no git
git_new_branch_from_tag(){
  local tag="$1"

  test -z "$tag" && echo "digite o nome da tag por parametro" && return 1

  git checkout -b "$tag" "$tag"
 }

# Função para renomear uma tag no git
git_rename_tags(){
    local old_tag="$1"
    local new_tag="$2"

    test -z "$old_tag" && echo "digite a tag antiga no 1º parametro" && return 1
    test -z "$new_tag" && echo "digite a tag nova no 2º parametro" && return 1

    if git rev-parse --is-inside-work-tree > /dev/null;then
        git tag "$new_tag" "$old_tag"
        git tag -d "$old_tag"
        git push origin ":refs/tags/${old_tag}"
        git push --tags
    else
        echo "ERROR: This folder is not a git repository"
        return 1
    fi
}

################################################################################
#  APT-GET ALIASES
################################################################################

# Função pra deletar os lock do apt-get.
# Usado principalmente, quando ele trava do nada.
# Além de reconfigurar o dpkg e resolver os pacotes quebrados
apt_get_fix(){
  test -f /var/lib/apt/lists/lock && sudo rm -rf /var/lib/apt/lists/lock
  test -f /var/cache/apt/archives/lock && sudo rm -rf /var/cache/apt/archives/lock
  test -f /var/lib/dpkg/lock && sudo rm -rf /var/lib/dpkg/lock
  test -f /var/lib/dpkg/lock-frontend && sudo rm -rf /var/lib/dpkg/lock-frontend

  sudo apt --fix-broken install
  sudo dpkg --configure -a
  echo "OK"
}

#################################################################
# Python Functions
#################################################################

# alias rápido que habilita um venv padrão no python
python_enable_venv(){
  if ! dpkg -s python3-venv > /dev/null 2>&1;then
    echo "instale primeiro o pacote:"
    echo "sudo apt install python3-venv"
  fi
  python3 -m venv venv
  source venv/bin/activate
}

# alias rápido que desabilita um venv no python
python_disable_venv(){
  deactivate
}

#################################################################
# Kubernetes Functions
#################################################################

k8s-reset-all-pods(){
    k delete pods --all --all-namespaces
}

k8s-list-all-resources(){
    k get all --all-namespaces
}

# Exploration functions
k8s-get-deployment(){
    local deploy_name=$1

    test -z $deploy_name && echo "Type deployment name by parameter" && return 1

    echo "Searching: $deploy_name"
    echo
    echo "------------------------------------"
    echo "Deployments"
    echo "------------------------------------"
    k get deploy -l app=${deploy_name}

    echo
    echo "------------------------------------"
    echo "ReplicaSets"
    echo "------------------------------------"
    k get rs -l app=${deploy_name}

    echo
    echo "------------------------------------"
    echo "Pods"
    echo "------------------------------------"
    k get po -l app=${deploy_name}

    echo
    echo "------------------------------------"
    echo "Rollout history"
    echo "------------------------------------"
    k rollout history deployment/${deploy_name}
}