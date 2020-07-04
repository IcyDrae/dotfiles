#!/bin/bash

copyBashRc() {
    BASHRC="$PWD/.bashrc"
    
    echo "Copying .bashrc into user directory..."
    cp $BASHRC ~/
    echo "Sourcing new .bashrc"
    source ~/.bashrc
}

copyVsCodeSettings() {
    SETTINGSJSON="$PWD/settings.json"
    VSCONFDIR=~/.config/Code/User/
    
    echo "Copying settings.json into $VSCONFDIR..."
    cp $SETTINGSJSON $VSCONFDIR
}

echo "Running copyBashRc"
copyBashRc
echo "end"

echo "Running copyBashRc"
copyVsCodeSettings
echo "end"