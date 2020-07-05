#!/bin/bash

GITSCRIPT="$PWD/git.sh"
CRONSCRIPT="$PWD/cron.sh"

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

    echo "Smylinking settings.json into $VSCONFDIR..."
    ln -sfv $SETTINGSJSON $VSCONFDIR
}

function zipPhpStormSettings() {
    SETTINGSDIR="phpstorm"

    echo "Zipping phpstorm into ~/.Desktop/settings.zip"
    cd $SETTINGSDIR
    zip -r ~/settings.zip ./*
}

linkBashRc

linkVsCodeSettings

zipPhpStormSettings

$GITSCRIPT
sudo $CRONSCRIPT
