################################################################################
# Arquivo de cores usado nos dotfiles.
# Fork desse arquivo https://github.com/jimeh/git-aware-prompt/blob/master/colors.sh
################################################################################

# Regular
text_black="$(tput setaf 0 2>/dev/null || echo '\e[0;30m')"  # Black
text_red="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"  # Red
text_green="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"  # Green
text_yellow="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"  # Yellow
text_blue="$(tput setaf 4 2>/dev/null || echo '\e[0;34m')"  # Blue
text_purple="$(tput setaf 5 2>/dev/null || echo '\e[0;35m')"  # Purple
text_cyan="$(tput setaf 6 2>/dev/null || echo '\e[0;36m')"  # Cyan
text_white="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"  # White

# Bold
bold_black="$(tput setaf 0 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;30m')"  # Black
bold_red="$(tput setaf 1 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;31m')"  # Red
bold_green="$(tput setaf 2 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;32m')"  # Green
bold_yellow="$(tput setaf 3 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;33m')"  # Yellow
bold_blue="$(tput setaf 4 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;34m')"  # Blue
bold_purple="$(tput setaf 5 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;35m')"  # Purple
bold_cyan="$(tput setaf 6 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;36m')"  # Cyan
bold_white="$(tput setaf 7 2>/dev/null)$(tput bold 2>/dev/null || echo '\e[1;37m')"  # White

# Underline
underline_black="$(tput setaf 0 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;30m')"  # Black
underline_red="$(tput setaf 1 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;31m')"  # Red
underline_green="$(tput setaf 2 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;32m')"  # Green
underline_yellow="$(tput setaf 3 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;33m')"  # Yellow
underline_blue="$(tput setaf 4 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;34m')"  # Blue
underline_purple="$(tput setaf 5 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;35m')"  # Purple
underline_cyan="$(tput setaf 6 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;36m')"  # Cyan
underline_white="$(tput setaf 7 2>/dev/null)$(tput smul 2>/dev/null || echo '\e[4;37m')"  # White

# Backgrounderline_
background_black="$(tput setab 0 2>/dev/null || echo '\e[40m')"  # Black
background_red="$(tput setab 1 2>/dev/null || echo '\e[41m')"  # Red
background_green="$(tput setab 2 2>/dev/null || echo '\e[42m')"  # Green
background_yellow="$(tput setab 3 2>/dev/null || echo '\e[43m')"  # Yellow
background_blue="$(tput setab 4 2>/dev/null || echo '\e[44m')"  # Blue
background_purple="$(tput setab 5 2>/dev/null || echo '\e[45m')"  # Purple
background_cyan="$(tput setab 6 2>/dev/null || echo '\e[46m')"  # Cyan
background_white="$(tput setab 7 2>/dev/null || echo '\e[47m')"  # White

# Reset
text_reset="$(tput sgr 0 2>/dev/null || echo '\e[0m')"  # text_ Resets


# Função pra imprimir informação
  function print_info(){
  	printf "${text_yellow}$1${text_reset}\n"
  }

  # Função pra imprimir mensagem de sucesso
  function print_success(){
  	printf "${text_green}$1${text_reset}\n"
  }

  # Função pra imprimir erros
  function print_error(){
  	printf "${text_red}[ERROR] $1${text_reset}\n"
  }
