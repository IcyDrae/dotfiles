#!/bin/bash

USER=$(logname)
GITSCRIPT="$PWD/git.sh"
CRONSCRIPT="$PWD/cron.sh"
TILIX="$PWD/tilix/tilix-defaults.sh"
DOCUMENTS=~/Documents/
SYSTEMD=/etc/systemd/system/

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

function linkSyncthingService() {
    SYNCTHING="$PWD/syncthing/syncthing@.service"

    echo "Symlinking syncthing service configuration into $SYSTEMD"
    ln -sfv $SYNCTHING $SYSTEMD # TODO change to copy instead of symlinking
    # in order for autostarting to work

    systemctl daemon-reload

    # Will start as the logged in user and the GUI will be reachable @127.0.0.1:8384(default)
    systemctl restart syncthing@$USER
}

linkBashRc

linkVsCodeSettings

linkCommands

linkSyncthingService

$GITSCRIPT
$CRONSCRIPT
$TILIX
