#!/usr/bin/env bash

query="$*"

if [[ -z "$query" ]]; then
    exit 1
fi

xdg-open "https://en.wikipedia.org/wiki/Special:Search?search=$(printf '%s' "$query" | jq -sRr @uri)"
