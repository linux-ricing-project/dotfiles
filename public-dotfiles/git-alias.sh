# Git Alias
################################################################################
# olhe: http://opensource.apple.com/source/Git/Git-19/src/git-htmldocs/pretty-formats.txt

  # <hash> <date> <user name> <commit message>
  alias gl='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"'

  # <hash> <date> <user email> <commit message>
  alias gle='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"'

  # imprime apenas o ultimo commit
  alias git_last_commit="git log -1 --pretty=%s"

  # desfaz as alteração do stage
  alias git_unstage="git reset HEAD"

  # pega o nome do repositório do git
	alias git_repository_name="git config --get --local remote.origin.url"

	# Deleta todas as branches locais, deixando só a current branch
	alias git_clean_branches="git branch | grep -v \"\*\" | xargs -n 1 git branch -D && git fetch --prune"

  # undo commit, and files back to the 'stage area'
  alias git_undo_commit="git reset --soft HEAD^"

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

  # Função pra encurtar URLs do github
github_shorten_url(){
  local url="$1"
  local code="$2"
  test -z "$url" && echo "digite a URL que você quer encurtar" && return 1
  test -z "$code" && echo "digite o nome customizado da URL" && return 1
  curl --silent https://git.io/ -i -F "url=$url" -F "code=$code" | grep "Location" | awk '{print $2}'
}

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