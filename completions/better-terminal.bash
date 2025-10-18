#!/usr/bin/env bash

_better_terminal_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "-c #75507B #FF0000 #00FF00 #0000FF #FFFFFF #000000" -- "$cur") )
    else
        COMPREPLY=( $(compgen -W "#75507B #FF5733 #5E81AC #00FF00 #0000FF" -- "$cur") )
    fi
}

complete -F _better_terminal_completions better-terminal
