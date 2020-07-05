#!/bin/bash

GITSCRIPT="$PWD/git.sh"
CRONSCRIPT="$PWD/cron.sh"

function copyBashRc() {
    BASHRC="$PWD/.bashrc"
    
    echo "Copying .bashrc into user directory..."
    cp $BASHRC ~/
    echo "Sourcing new .bashrc"
    source ~/.bashrc
}

function copyVsCodeSettings() {
    SETTINGSJSON="$PWD/vscode/settings.json"
    VSCONFDIR=~/.config/Code/User/
    
    echo "Copying settings.json into $VSCONFDIR..."
    cp $SETTINGSJSON $VSCONFDIR
}

function copyPhpStormSettings() {
    SETTINGSDIR="phpstorm"

    echo "Zipping phpstorm into ~/.Desktop/settings.zip"
    cd $SETTINGSDIR
    zip -r ~/settings.zip ./*
}

copyBashRc

copyVsCodeSettings

copyPhpStormSettings

$GITSCRIPT
sudo $CRONSCRIPT
