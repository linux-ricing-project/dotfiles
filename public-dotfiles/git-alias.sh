# Git Alias
################################################################################
# olhe: http://opensource.apple.com/source/Git/Git-19/src/git-htmldocs/pretty-formats.txt

  # <hash> <date> <user name> <commit message>
  alias gl='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %aN%Creset %s"'

  # <hash> <date> <user email> <commit message>
  alias gle='git log -n 20 --oneline --date=short --pretty=format:"%Cgreen%h%Creset %Cred%ad%Creset %Cblue% %ae%Creset %s"'

  # imprime apenas o ultimo commit
  alias git_last_commit="git log -1 HEAD"

  # desfaz as alteração do stage
  alias git_unstage="git reset HEAD"

  # pega o nome do repositório do git
	alias git_repository_name="git config --get --local remote.origin.url"

	# Deleta todas as branches locais, deixando só a current branch
	alias git_clean_branches="git branch | grep -v \"\*\" | xargs -n 1 git branch -D && git fetch --prune"

  # undo commit, and files back to the 'stage area'
  alias git_undo_commit="git reset --soft HEAD^"

  # basicamente adiciona as modificações correntes no último commit
  alias git_edit_last_commit="git commit --amend --no-edit"

  # remove all untracked files, is case of you want to clean in repo.
  function git_remove_untracked_files(){
    rm -rf $(git ls-files --others --exclude-standard | xargs)
  }

  # Função que cria uma nova branch local, a partir deu uma tag no git
  function git_new_branch_from_tag(){
    local tag="$1"

    test -z "$tag" && echo "digite o nome da tag por parametro" && return 1

    git checkout -b "$tag" "$tag"
  }

  # Função para renomear uma tag no git
  function git_rename_tags(){
    local old_tag="$1"
    local new_tag="$2"

    test -z "$old_tag" && echo "digite a tag antiga no 1º parametro" && return 1
    test -z "$new_tag" && echo "digite a tag nova no 2º parametro" && return 1

    git tag "$new_tag" "$old_tag"
    git tag -d "$old_tag"
    git push origin ":refs/tags/${old_tag}"
    git push --tags
  }

  # Função pra encurtar URLs do github
  function github_shorten_url(){
    local url="$1"
    local code="$2"
    test -z "$url" && echo "digite a URL que você quer encurtar" && return 1
    test -z "$code" && echo "digite o nome customizado da URL" && return 1
    curl --silent https://git.io/ -i -F "url=$url" -F "code=$code" | grep "Location" | awk '{print $2}'
  }

  # alias rápido para commitar e dar git push ao mesmo tempo
  function git_commit_push(){
    local commit_msg=$1

    if [ -n "$commit_msg" ];then
      local current_branch=$(git branch | grep "^*" | awk '{print $2}')

      git commit -a -m "$commit_msg"

      local has_conflict=$(git_verify_conflict)
      # se o $has_conflict for nulo, não teve conflito
      if [ -z "$has_conflict" ];then
        git pull
        git push origin "$current_branch"
      else
        printf "$has_conflict"
        return 1
      fi

    else
      echo "digite a mensagem do commit"
      return 1
    fi

  }

  # verifica se tem conflito com o remote
  function git_verify_conflict(){
    #  verificando se é um diretorio git
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1;then
      local current_branch=$(git branch | grep "^*" | awk '{print $2}')

      git fetch > /dev/null 2>&1
      # faz um merge sem commit e salva nesse arquivo temporário
      git merge origin/${current_branch} --no-commit --no-ff > .conflict.txt 2>&1
      if grep -q "CONFLICT" .conflict.txt;then
          local conflict_file=$(grep "CONFLICT" .conflict.txt | awk '{print $6}')
          # caso tenha conflito, formata a mensagem bonitinha
          echo
          echo "============ CONFLICT ============"
          printf "${text_red}CONFLICT${text_reset} in ${text_yellow}${conflict_file}${text_reset}\n"
          echo "=================================="
          echo
      fi
      local git_root_directory=$(git rev-parse --show-toplevel)
      #  verificação para saber se existe merge a ser abortado
      if [ $(find $git_root_directory -iname "MERGE_HEAD" | wc -l) != "0" ];then
        # aborta o merge, e deleta o arquivo temporário
        git merge --abort
      fi
      test -f .conflict.txt && rm -rf $_
    fi
  }

  # Função que troca de branch rapidamente
  function change_branch(){
    local new_branch="$1"

    local default_branch=$(git remote show $(git remote) | sed -n '/HEAD branch/s/.*: //p')

    git checkout "$default_branch"
    git pull

    if [ -n "$new_branch" ];then
      git checkout "$new_branch"
    fi
  }