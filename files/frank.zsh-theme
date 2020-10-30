text_blue="%{$FG[012]%}"
text_yellow="%{$FG[003]%}"
text_red="%{$FG[001]%}"
text_cyan="%{$FG[006]%}"
text_green="%{$FG[002]%}"
text_purple="%{$FG[005]%}"
text_gray="%{$FG[008]%}"
reset_color="%{$reset_color%}"

peace_symbol=$(echo -e "\u262E")

# https://emojipedia.org/yin-yang/
yin_yang=$(echo -e "\u262F")

# https://www.nerdfonts.com/cheat-sheet
ubuntu=""
home_icon=$(echo -e "\ufcd0")

# current directory
directory() {
    current_dir="[%1~]"
    home_icon="\uf7db"
    if [ "$(pwd)" = "$HOME" ];then
        echo "${text_blue}${home_icon}${reset_color}"
    else
        echo "${text_blue}${current_dir}${reset_color}"
    fi
}

find_icon(){
    github_icon="\ue709"
    gitlab_icon="\uf296"
    icons="${text_blue}"
    # cheque se é um repositório git
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1;then

        # veja se é github ou gitlab
        if git remote -v | grep -q "github" > /dev/null;then
            [[ ! -z "$icons" ]] && icons+=" "
            icons+="${github_icon}"
        elif git remote -v | grep -q "gitlab" > /dev/null;then
            [[ ! -z "$icons" ]] && icons+=" "
            icons+="${gitlab_icon}"
        fi

        # procure por código python
        if [ $(find . -iname "*.py" | wc -l) != 0 ];then
            [[ ! -z "$icons" ]] && icons+=" "
            icons+="\ue73c"
        fi
    fi

    if [ "$icons" =  ${text_blue} ];then
        icons=""
    else
        icons+="${reset_color}"
    fi

    echo -e "$icons"
}

# returns ☯️ if there are errors, nothing otherwise
return_status() {
    local error="${text_red}$(echo -e "\u2716")${reset_color}"
    local success="${text_green}$(echo -e "\u2714")${reset_color}"

    echo "%(?.${success}.${error})"
}

# see: https://unix.stackexchange.com/a/485832
function preexec() {
    timer=${timer:-$SECONDS}
}

function precmd() {
    if [ $timer ]; then
        time="0"
        segundos=$(($SECONDS - $timer))
        minutos=$(($segundos / 60))
        horas=$(($minutos / 60))

        if ((segundos < 60));then
            time="${segundos}s"
        elif ((minutos > 0));then 
            time="${minutos}.$(echo $(($segundos % 60)))m"
        elif ((horas > 0));then
            time="${horas}.$(echo $(($minutos % 60)))h"
        fi
        export RPROMPT="${time}$(find_icon) $(return_status)"
        unset timer
    fi
}

# coloca um separador no final do comando
function separador() {
    string='.'
    repeticoes=$(tput cols)
    valor=$(printf "%-${repeticoes}s" "$string")
    echo "${valor// /${string}}\n"
}

# git info
ZSH_THEME_GIT_PROMPT_PREFIX="${text_yellow}(:"
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="✨"

# git status
ZSH_THEME_GIT_PROMPT_UNTRACKED="${text_red}[untracked]"
ZSH_THEME_GIT_PROMPT_ADDED="${text_green}[added]"
ZSH_THEME_GIT_PROMPT_MODIFIED="${text_cyan}[modified]"
ZSH_THEME_GIT_PROMPT_RENAMED="${text_yellow}[renamed]"
ZSH_THEME_GIT_PROMPT_DELETED="${text_red}[deleted]"
ZSH_THEME_GIT_PROMPT_STASHED="${text_yellow}[stashed]"
ZSH_THEME_GIT_PROMPT_UNMERGED="${text_purple}[unmerged]"
ZSH_THEME_GIT_PROMPT_AHEAD="${text_purple}[ahead]"
ZSH_THEME_GIT_PROMPT_BEHIND="${text_purple}[behind]"
ZSH_THEME_GIT_PROMPT_DIVERGED="${text_purple}[conflict]"


# putting it all together
# PROMPT='$(separador) $(git_prompt_info) $(git_prompt_status)
# $(peace_symbol) $(yin_yang) | %B$(directory)%b '

PROMPT="${text_gray}$(separador)${reset_color}"
PROMPT+='${ubuntu} ${peace_symbol} ${yin_yang} | %B$(directory)%b'
PROMPT+='$(git_prompt_info)$(git_prompt_status) '
PROMPT+=" ${reset_color}> "
