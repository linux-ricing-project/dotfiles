#  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
#  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
#  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
#  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
#  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
#  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝


# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json(){
  if type jq > /dev/null 2>&1;then
    jq '.' $*
  else
    echo "instalando o jq"
    sudo apt-get install -y jq
    echo "execute o comando novamente"
  fi
}

alias matrix="cmatrix -b -s -u 6"

# Clipboard
# use: "echo mensagem | copiar"
# OBS: 'xclip' não vem instalado por padrão no SO.
alias copiar='xclip -selection c'
alias colar='xclip -selection clipboard -o'


# Ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
# alias pra pegar o clima
alias clima='curl pt.wttr.in'

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

# função para abrir o Disk Usage Analyzer (baobab)
# caso não esteja instalado, dando erro ele instala pra mim
# ---------------------------------
# OBS: é melhor usar o 'pkexec' do que o "gksudo".
# Porque o 'gksudo' é um pacote que não tem nos repositórios
# do Ubuntus mais novos
# ---------------------------------
# PARAM: o diretório que quer analizar
disk_analyser(){
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

# função pra add job no cron programaticamente
add_cronjob(){
  local comando=$1

  (crontab -l 2> /dev/null ; echo "$comando") \
  | sort - | uniq - | crontab -
}

# Comando para matar um processo de forma mais fácil.
pskill(){
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

# alias do youtube-dl apontando para imagem do docker
alias youtube-dl='docker run --rm -u $(id -u):$(id -g) -v $PWD:/data vimagick/youtube-dl'
# download video do youtube
alias youtube_download="youtube-dl --add-metadata -i -o '%(upload_date)s-%(title)s.%(ext)s'"
# download apenas o audio do vídeo do youtube em mp3
alias youtube_download_audio="youtube-dl --add-metadata --audio-format 'mp3' -xic -o '%(title)s.%(ext)s'"
