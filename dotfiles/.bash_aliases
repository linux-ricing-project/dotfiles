
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#       								~/.bash_aliases de Frank
# 			       					Welcome and don't Panic =D
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# [Descrição]:
#
# Arquivo onde fica todas os alias e funções
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Configurações
#-------------------------------------------------------------------------------
# seta o teclado pra pt-br
  setxkbmap -layout br

  # carregando as cores
  if [ -L ~/.colors.sh ]; then
      . ~/.colors.sh
  fi

# Alias Padrões
#-------------------------------------------------------------------------------
	# pra Linux
	if [ "Linux" = $(uname -s) ]; then
		alias ls='ls --color=auto'
		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	# pra Mac
	else
		export GREP_OPTIONS="--color=auto"
		export GREP_COLOR="4;33"
		export CLICOLOR="auto"

		alias ls="ls -G"
	fi


# Utilidades - Commons
#-------------------------------------------------------------------------------

  # Função pra imprimir informação
  function print_info(){
  	printf "${text_yellow}$1${textreset}\n"
  }

  # Função pra imprimir mensagem de sucesso
  function print_success(){
  	printf "${text_green}$1${textreset}\n"
  }

  # Função pra imprimir erros
  function print_error(){
  	printf "${text_red}[ERROR] $1${textreset}\n"
  }

  # Syntax-highlight JSON strings or files
  # Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
  function json() {
    if dpkg -s python-pygments > /dev/null 2>&1;then
    	if [ -t 0 ]; then # argumento
        if [ -f $1 ];then # verifica se o argumento é um file.
          python -mjson.tool <<< "$(cat $1)" | pygmentize -l javascript;
        else
          python -mjson.tool <<< "$*" | pygmentize -l javascript;
        fi
    	else # pipe
    		python -mjson.tool | pygmentize -l javascript;
    	fi;
    else
      echo "instalando python-pygments..."
      sudo apt-get install -y python-pygments
      echo "execute o comando novamente"
    fi

}

  # alias de navegação
  alias ..="cd .."
  alias cd..="cd .."
  alias back="cd -"

  # lista os alias de forma mais amigável
  alias aliases="alias | sed 's/=.*//'"

  # lista todas as funções de forma mais amigável
  alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

  # print $path mais amigável
  alias path='echo $PATH | tr ":" "\n" | sort'

  # print 'ls -lha' com formato de timestamp
  alias ll='ls -l --time-style=+"%d-%m-%Y %H:%M:%S" --color -h -a'

  # get folder size
  alias size='du -sh'

  # get and print folder size for all folders, recursively
  alias sizer='du -h -c'

	# troca para versões do java instalado no computador
	alias trocar_java='sudo update-alternatives --config java'

  # função para abrir o Disk Usage Analyzer (baobab)
	# caso não esteja instalado, dando erro ele instala pra mim
	# PARAM: o diretório que quer analizar
	function disk_analyser(){
		if type gksu > /dev/null 2>&1;then
			gksudo baobab $1 2> /dev/null
		else
			print_info "Instalando dependencias..."
			sudo apt-get install -y gksu
			clear
			print_info "Abrindo..."
			gksudo baobab $1 2> /dev/null
		fi
  }

	# procura facilmente por um processo rodando
	function psgrep() {
		ps -aux | grep $1 | grep -v grep
	}

	# mata mais facilmente um processo rodando
	function pskill() {
		local pid
		local nome_do_processo=$1

		pid=$(ps -ax | grep $nome_do_processo | grep -v grep | awk '{ print $1 }')
		echo -n "killing $nome_do_processo (process $pid)..."
		kill -9 $pid
		echo "$nome_do_processo morto!"
	}

	# limpa a lixeira
	function limpar_lixeira(){
		print_info "Limpando lixeira...."
		rm -rf  ~/.local/share/Trash/*
		print_info "Lixeira vazia!"
	}

	# atualiza o computador e limpa os pacotes .deb
	# lá de '/var/cache/apt/archives/'
	function atualizar_computador(){
		print_info "======= Update ======="
		sudo apt-get update
		print_info "======= Upgrade ======="
		sudo apt-get upgrade -y
		sudo apt-get dist-upgrade -y
		print_info "======= Limpando as dependencias ======="
		sudo apt-get -f -y install # resolvendo pacotes quebrados
		sudo apt-get autoremove -y
		sudo apt-get clean -y
	}

	# alias pra extrair aquivo compactado.
	function extract {
		local file=$1

	 if [ -z "$file" ]; then
	    # display usage if no parameters given
	    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
	    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
	    return 1
	 else
	    for n in $@; do
	      if [ -f "$n" ] ; then
	        case "${n%,}" in
	          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
	                       tar xvf "$n"       ;;
	          *.lzma)      unlzma ./"$n"      ;;
	          *.bz2)       bunzip2 ./"$n"     ;;
	          *.rar)       unrar x -ad ./"$n" ;;
	          *.gz)        gunzip ./"$n"      ;;
	          *.zip)       unzip ./"$n"       ;;
	          *.z)         uncompress ./"$n"  ;;
	          *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
	                       7z x ./"$n"        ;;
	          *.xz)        unxz ./"$n"        ;;
	          *.exe)       cabextract ./"$n"  ;;
	          *)
		           echo "extract: '$n' - unknown archive method"
		           return 1
	           ;;
	        esac
	      else
	        echo "'$n' - file does not exist"
	        return 1
	      fi
	    done
	fi
	}

  # restartar o adb
  function adb_restart {
    sudo adb 'kill-server'
    sleep 2
    sudo adb start-server
  }

  # minha tag no logcat
  alias minha_tag='adb logcat -s "fcbj":v'


  # Carregando arquivos
  #-------------------------------------------------------------------------------

  # carregando o .private_aliases
  if [ -L ~/.private_aliases ]; then
      . ~/.private_aliases
  fi

  # carregando o .git_prompt
  if [ -L ~/.git_prompt ]; then
      . ~/.git_prompt
  fi
