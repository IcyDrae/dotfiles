#!/usr/bin/env zsh

languages="javascript java sql docker"
core_utils="xargs find mv sed awk"

selected=$(printf "%s\n" $=languages $=core_utils | fzf)

read "query?Query: "

if printf "%s\n" $=languages | grep -Fxq "$selected"; then
    query=$(printf "%s" "$query" | tr ' ' '+')
    curl "https://cht.sh/$selected/$query"
else
    query=$(printf "%s" "$query" | tr ' ' '+')
    curl "https://cht.sh/$selected~$query"
fi
