#!/usr/bin/env bash

query="$*"

if [[ -z "$query" ]]; then
    exit 1
fi

if [[ "$query" =~ ^([a-zA-Z-]+):[[:space:]]*(.*)$ ]]; then
    language="${BASH_REMATCH[1]}"
    text="${BASH_REMATCH[2]}"
else
    language="en"
    text="$query"
fi

encoded=$(printf '%s' "$text" | jq -sRr @uri)

xdg-open "https://translate.google.com/?sl=auto&tl=${language}&text=${encoded}"

