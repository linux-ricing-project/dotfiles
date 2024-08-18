#!/bin/bash

# Start tmux, list all active sessions with fzf, and open it
tstart(){
    tmux start && tmux a -t "$(tmux ls -F "#{session_name}" | fzf --height 40% --prompt="Select a tmux session: ")"
}

xstart(){
  projects=$(tmuxinator list | tail -n +2 | tr ' ' '\n' | sed '/^\s*$/d')

  # Usa o fzf para selecionar um projeto
  selected_project=$(echo "$projects" | fzf --height 40% --border --prompt="Select a tmuxinator project: ")

  # Verifica se um projeto foi selecionado
  if [ -n "$selected_project" ]; then
    # Inicia o projeto selecionado
    tmuxinator start "$selected_project"
  else
    echo "Nenhum projeto selecionado."
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