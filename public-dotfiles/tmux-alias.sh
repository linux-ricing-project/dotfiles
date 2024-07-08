#!/bin/bash

# Start tmux, list all active sessions with fzf, and open it
tstart(){
    tmux start && tmux a -t "$(tmux ls -F "#{session_name}" | fzf --height 40%)"
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