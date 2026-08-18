#!/usr/bin/env bash

query="$*"

if [[ -z "$query" ]]; then
    exit 1
fi

xdg-open "https://github.com/search?q=$(printf '%s' "$query" | jq -sRr @uri)"
