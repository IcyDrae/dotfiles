# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Custom
# ls aliases
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36:cd=36'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias lt='ls -lhtr --color=auto'
alias lx='ls -lXB --color=auto'
alias lS='ls -lS --color=auto'
alias tree='tree -C'  # colorize tree

# Navigation and dirs
mcd() {
	mkdir -p $1
	cd $1
}

alias fhere="find . -name "

alias ..='cd ..'

# System shortcuts
alias update='sudo dnf update -y'
alias rebootnow='sudo systemctl reboot'
alias shutdownnow='sudo systemctl poweroff'
alias ports='sudo ss -tulnp'
alias myip="curl ifconfig.me"

# Quick extraction
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1" ;;
            *.tar.gz)    tar xzf "$1" ;;
            *.bz2)       bunzip2 "$1" ;;
            *.rar)       unrar x "$1" ;;
            *.gz)        gunzip "$1" ;;
            *.tar)       tar xf "$1" ;;
            *.tbz2)      tar xjf "$1" ;;
            *.tgz)       tar xzf "$1" ;;
            *.zip)       unzip "$1" ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1" ;;
            *)           echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Smart sudo: rerun last command with sudo if it failed
smart_sudo() {
    # Save last command
    last_cmd=$(history | tail -n2 | head -n1 | sed 's/^[ ]*[0-9]*[ ]*//')
    
    # Try running it
    eval "$last_cmd"
    
    # If it fails with permission denied, retry with sudo
    if [ $? -ne 0 ]; then
        echo "Retrying with sudo..."
        sudo $last_cmd
    fi
}

# Shortcut: !! → smart sudo
alias please='smart_sudo'

# Only load Liquid Prompt in interactive shells, not from a script or from scp
[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt

