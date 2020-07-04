#!/bin/bash

GITSCRIPT="$PWD/git.sh"

copyBashRc() {
    BASHRC="$PWD/.bashrc"
    
    echo "Copying .bashrc into user directory..."
    cp $BASHRC ~/
    echo "Sourcing new .bashrc"
    source ~/.bashrc
}

copyVsCodeSettings() {
    SETTINGSJSON="$PWD/vscode/settings.json"
    VSCONFDIR=~/.config/Code/User/
    
    echo "Copying settings.json into $VSCONFDIR..."
    cp $SETTINGSJSON $VSCONFDIR
}

copyPhpStormSettings() {
    SETTINGSDIR="phpstorm"

    echo "Zipping phpstorm into ~/.Desktop/settings.zip"
    cd $SETTINGSDIR
    zip -r ~/settings.zip ./*
}

copyBashRc

copyVsCodeSettings

copyPhpStormSettings

$GITSCRIPT
