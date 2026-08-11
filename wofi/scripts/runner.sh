#!/usr/bin/env bash

set -u

choice=$(
    printf '%s\n' \
        "Applications" \
        "Calculator" \
        "Google Search" \
        "YouTube Search" \
        "GitHub Search" \
        "Wikipedia Search" \
        "Translate" \
        "Open URL" \
        "Run Command" \
        | wofi --dmenu \
            --insensitive \
            --matching fuzzy \
            --prompt "Exec"
)

case "$choice" in

    "Applications")
        wofi --show drun
        ;;

    "Calculator")
        query=$(printf '' | wofi --dmenu --prompt "Calculate")
        [[ -z "$query" ]] && exit 0

        result=$(calc.sh "$query")

        printf '%s\n' "$result" \
            | wofi --dmenu --prompt "Result"
        ;;

    "Google Search")
        query=$(printf '' | wofi --dmenu --prompt "Google")
        [[ -z "$query" ]] && exit 0

        g.sh "$query"
        ;;

    "YouTube Search")
        query=$(printf '' | wofi --dmenu --prompt "YouTube")
        [[ -z "$query" ]] && exit 0

        yt.sh "$query"
        ;;

    "GitHub Search")
        query=$(printf '' | wofi --dmenu --prompt "GitHub")
        [[ -z "$query" ]] && exit 0

        gh.sh "$query"
        ;;

    "Wikipedia Search")
        query=$(printf '' | wofi --dmenu --prompt "Wikipedia")
        [[ -z "$query" ]] && exit 0

        wikipedia.sh "$query"
        ;;

    "Translate")
        query=$(printf '' | wofi --dmenu --prompt "Translate")
        [[ -z "$query" ]] && exit 0

        translate.sh "$query"
        ;;

    "Open URL")
        url=$(printf '' | wofi --dmenu --prompt "URL")
        [[ -z "$url" ]] && exit 0

        xdg-open "$url"
        ;;

    "Run Command")
        command=$(printf '' | wofi --dmenu --prompt "Run")
        [[ -z "$command" ]] && exit 0

        bash -lc "$command"
        ;;
esac

