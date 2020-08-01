#!/bin/bash

GITSCRIPT="$PWD/git.sh"
CRONSCRIPT="$PWD/cron.sh"
TILIX="$PWD/tilix/tilix-defaults.sh"
DOCUMENTS=~/Documents/

function linkBashRc() {
    BASHRC="$PWD/.bashrc"

    echo "Symlinking .bashrc into user directory..."
    ln -sfv $BASHRC ~/
    echo "Sourcing new .bashrc"
    source ~/.bashrc
}

function linkVsCodeSettings() {
    SETTINGSJSON="$PWD/vscode/settings.json"
    VSCONFDIR=~/.config/Code/User/

    echo "Symlinking settings.json into $VSCONFDIR..."
    ln -sfv $SETTINGSJSON $VSCONFDIR
}

function linkCommands() {
    COMMANDS="$PWD/commands/general"

    echo "Symlinking useful commands into $DOCUMENTS"
    ln -sfv $COMMANDS $DOCUMENTS
}

linkBashRc

linkVsCodeSettings

linkCommands

$GITSCRIPT
$CRONSCRIPT
$TILIX
