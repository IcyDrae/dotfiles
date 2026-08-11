#!/usr/bin/env bash

query="$*"

if [[ -z "$query" ]]; then
    exit 1
fi

xdg-open "https://www.youtube.com/results?search_query=$(printf '%s' "$query" | jq -sRr @uri)"

