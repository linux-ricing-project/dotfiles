#  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
#  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
#  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
#  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
#  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
#  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝

# exibindo sysinfo e system logo com o neofetch
if which neofetch > /dev/null 2>&1 ;then
  neofetch
fi


  # Syntax-highlight JSON strings or files
  # Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
  function json() {
    if type jq > /dev/null 2>&1;then
    	jq '.' $*
    else
      echo "instalando o jq"
      sudo apt-get install -y jq
      echo "execute o comando novamente"
    fi
  }

  # Clipboard
  # use: "echo mensagem | copiar"
  # OBS: 'xclip' não vem instalado por padrão no SO.
  alias copiar='xclip -selection c'
  alias colar='xclip -selection clipboard -o'


  # Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
  # alias pra pegar o clima
  alias clima='curl pt.wttr.in'

  # alias rápido que habilita um venv padrão no python
  function python_enable_venv(){
    if ! dpkg -s python3-venv > /dev/null 2>&1;then
      echo "instale primeiro o pacote:"
      echo "sudo apt install python3-venv"
    fi
    python3 -m venv venv
    source venv/bin/activate
  }

  # alias rápido que desabilita um venv no python
  function python_disable_venv(){
    deactivate
  }

  # função para abrir o Disk Usage Analyzer (baobab)
	# caso não esteja instalado, dando erro ele instala pra mim
  # ---------------------------------
  # OBS: é melhor usar o 'pkexec' do que o "gksudo".
  # Porque o 'gksudo' é um pacote que não tem nos repositórios
  # do Ubuntus mais novos
  # ---------------------------------
	# PARAM: o diretório que quer analizar
	function disk_analyser(){
		if type baobab > /dev/null 2>&1;then
			pkexec baobab $1 2> /dev/null
		else
			print_info "Instalando Disk Analyzer ('baobab' package)"
			sudo apt install -y baobab
			clear
			print_info "Abrindo..."
			pkexec baobab $1 2> /dev/null
		fi
  }

  # alias temporário para corrigir o bug de cloudormation-capabilities do ansible.
  # sempre que o ansible é atualziado via apt-get, ele perde o fix.
  function fix_ansible_capabilities(){
    # variável que guarda o local de instalação do ansible.
    # OBS: esses dois 'dirname' estão aí, pq um pega o 'dirname' do comando 'ansible'
    # 	O outro pega o 'dirname' do diretório bin, ou seja, eles removem o '/bin/ansible' da string
    local ansible_installation=$(dirname $(dirname $(which ansible)))

    # variável que guarda o endereço absoluto do 'cloudformation.py'
    local cloudformation_module=$(find "$ansible_installation" -iname "cloudformation.py" | grep modules)

    if ! grep -q "CAPABILITY_NAMED_IAM', 'CAPABILITY_AUTO_EXPAND" "$cloudformation_module"; then
      sudo sed -i "s/CAPABILITY_NAMED_IAM/CAPABILITY_NAMED_IAM', 'CAPABILITY_AUTO_EXPAND/g" "$cloudformation_module"
      echo "arquivo 'cloudformation.py' alterado com sucesso!"
    else
      echo "OK: O arquivo 'cloudformation.py' já foi alterado com o 'CAPABILITY_AUTO_EXPAND'"
    fi
  }

  # função pra add job no cron programaticamente
  function add_cronjob(){
    local comando=$1

    (crontab -l 2> /dev/null ; echo "$comando") \
    | sort - | uniq - | crontab -
  }

  # Comando para matar um processo de forma mais fácil.
  function pskill(){
    local process_name=$1

    if [ -z "$process_name" ];then
      echo "insert process name as parameter"
      return 1
    fi

    local pid=$(ps -ax | grep $process_name | grep -v grep | awk '{ print $1 }')
    echo -n "killing $process_name..."
    kill -9 $pid
    echo "process $pid"
    echo "$process_name morto!"
  }

#   Comando para atualizar o Visual Studio Code.
#   Esse script é necessário, pois sempre que lança umaversão nova do vscode,
#   ele pede pra baixar o arquivo .deb do site.
#   Esse script faz isso automaticamente
function update_vscode(){
  local vscode_url_download="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

  local temp_file="/tmp/code_latest_amd64.deb"

  # baixa a versão nova do vscode do site, para o /tmp
  wget "$vscode_url_download" -O "$temp_file"

  # instala o novo pacote .deb
  sudo dpkg -i "$temp_file"

  # remove o arquivo temporário
  rm -rf "$temp_file"
}

  # alias do youtube-dl apontando para imagem do docker
  alias youtube-dl='docker run --rm -u $(id -u):$(id -g) -v $PWD:/data vimagick/youtube-dl'
  # download video do youtube
  alias youtube_download="youtube-dl --add-metadata -i -o '%(upload_date)s-%(title)s.%(ext)s'"
  # download apenas o audio do vídeo do youtube em mp3
  alias youtube_download_audio="youtube-dl --add-metadata --audio-format 'mp3' -xic -o '%(title)s.%(ext)s'"
