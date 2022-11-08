# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# [Descrição]:
#
# Arquivo onde fica toda a configuração do prompt
# Deve ser carregado no ~/.bashrc
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Funções do Prompt
#------------------------------------------------------------------------------

	# imprime as modificações do git
	function git_prompt {
		local git_prompt=""
		local current_branch=""
		local untracked_files=""

		# se for um diretório git, faça as operações
    	if git rev-parse --is-inside-work-tree > /dev/null 2>&1;then
			current_branch=$(git branch 2> /dev/null | grep ^* | awk '{print $2}')
			git_prompt=$current_branch

			# verifique se tem "untracked files" (novos arquivos)
			untracked_files=$(git ls-files --others --exclude-standard | wc -l)
			if (( $untracked_files >= 1 ));then
				git_prompt="${git_prompt}${text_yellow}|${text_red}untracked +${untracked_files}"
			else
				git_prompt="$git_prompt"
			fi

			# verifica se tem "modified files"
			modified_files=$(git ls-files --modified | wc -l)
			if (( $modified_files >= 1 ));then
				git_prompt="${git_prompt}${text_yellow}|${text_cyan}modified +$modified_files"
			else
				git_prompt="$git_prompt"
			fi

			# verifica se tem arquivos para ser comitados
			added_files=$(git diff --name-only --cached | wc -l)
			if (( $added_files >= 1 ));then
				git_prompt="${git_prompt}${text_yellow}|${text_green}added +$added_files"
			else
				git_prompt="$git_prompt"
			fi

			# verifica se algo no stash
			stashed_files=$(git stash list | wc -l)
			if (( $stashed_files >= 1 ));then
				git_prompt="${git_prompt}${text_yellow}|${text_yellow}stashed +$stashed_files"
			else
				git_prompt="$git_prompt"
			fi

			upstream_count=$(git rev-list --count --left-right @{upstream}...HEAD | tr "\t" "-")
			upstream=""
			case "$upstream_count" in
				# no upstream
				"") upstream="" ; pipe="" ;;
				# equal to upstream
				"0-0") upstream="" ; pipe="" ;;
				# ahead of upstream
				"0-"*) upstream="ahead +$(echo $upstream_count | cut -d "-" -f2)" ; pipe="${text_yellow}|" ;;
				# behind upstream
				*"-0") upstream="behind +$(echo $upstream_count | cut -d "-" -f1)" ; pipe="${text_yellow}|" ;;
				# diverged from upstream
				*)
					# se for divergente, verifique se existe indicios de conflito
					# (depois de ter executado o 'git pull').
					# enquanto não existir, é apenas um "head +1 e behind +1".
					# se achar o marcador do conflito, aí sim o resultado é "conflict"
					if grep -r "<<<<<<< HEAD" . | grep -v ".git_prompt" > /dev/null 2>&1 ; then
						upstream="conflict"
						pipe="${text_yellow}|"
					else
						ahead="ahead +$(echo $upstream_count | cut -d "-" -f2)"
						behind="behind +$(echo $upstream_count | cut -d "-" -f1)"
						pipe="${text_yellow}|${text_purple}"
						upstream="${ahead}${pipe}${behind}"
					fi
				;;
			esac

			git_prompt="${git_prompt}${pipe}${text_purple}${upstream}"

			echo "${text_yellow}(${git_prompt}${text_yellow})${text_reset}"

		# ... se não for, não imprima nada
		else
			echo "${text_yellow}${git_prompt}${text_reset}"
		fi
 	}

	# Pinta de AZUL se o comando anterior rodou com sucesso
	function parse_erro {
		if [[ $? = "0" ]]; then
			echo "$text_blue"
		# ... se não, pinta de vermelho
		else
			echo "$text_red"
		fi
	}

	# coloca um separador no final do comando
	function separador() {
		string='-'
		repeticoes=$(tput cols)
		valor=$(printf "%-${repeticoes}s" "$string")
		echo "${valor// /-}\n"
	}

	function timer_now() {
    date +%s%N
	}

	function timer_start() {
    timer_start=${timer_start:-$(timer_now)}
	}

	function timer_stop() {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
	}

	# Função principal, que monta a variável PS1
	function set_prompt(){
		PS1=$(parse_erro)
		PS1+=$(separador)

		timer_stop
		PS1+="(${timer_show})"

		PS1+="[\W]:"
		PS1+=$(git_prompt)
		PS1+=$text_reset
		PS1+="\n\$ "
	}

# Prompt's
#---------------------------------------------------------------------------------------
# Prompt de Frank
	trap 'timer_start' DEBUG
	PROMPT_COMMAND="set_prompt"

# Prompt de Aurélio Jargas
# PROMPT_COMMAND='__git_ps1 "\033[42;30m\u@\h:\w\033[m" "\n\\\$ "'

# Prompt de Well
	#PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'
