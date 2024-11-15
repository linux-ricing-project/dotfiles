#!/bin/bash

# Start tmux, list all active sessions with fzf, and open it
tstart(){
    tmux start && tmux a -t "$(tmux ls -F "#{session_name}" | fzf --height 40% --prompt="Select a tmux session: ")"
}

# Open with 'Ctrl+O'
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