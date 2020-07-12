#!/bin/bash

# Installs Tilix[https://github.com/gnunn1/tilix/], sets it as
# the default terminal, and adds a monitoring workspace on autostart

USER=$(logname)
USERHOME="/home/$USER"
MONITORJSON="$PWD/tilix/monitor.json" # The workspace, in JSON form
STARTUPCOMM="$PWD/tilix/tilix-monitor.desktop"
AUTOSTARTCONF=$USERHOME/.config/autostart

function tilixDefaults() {

    # 1. Install what we need to get started
    for PACKAGE in tilix glances gpustat
    do
        if [ ! command -v $PACKAGE &> /dev/null]; then
            echo "$PACKAGE is not installed, installing..."
            printf "\n"
            sudo apt-get install $PACKAGE -y
        else
            echo "$PACKAGE is already installed, proceeding..."
            printf "\n"
        fi
    done

    # 2. Set defaults

    # Because start.sh needs to be run as root and gsettings is a user configuration system,
    # we need to find the RUID and run the gsettings command as the user

    # Get the Real Username
    RUID=$(who | awk 'FNR == 1 {print $1}')

    # Translate Real Username to Real User ID
    RUSER_UID=$(id -u ${RUID})

    echo "Setting Tilix as the default terminal..."
    sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/tilix
    sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

    # 3. Symlink our config and set autostart
    echo "Symlinking $MONITORJSON into user directory"
    printf "\n"
    ln -svf $MONITORJSON $USERHOME
    printf "\n"

    echo "Changing ownership..."
    sudo chown -h $USER:$USER "$USERHOME/monitor.json" -v
    printf "\n"

    if [ ! -d $AUTOSTARTCONF ] ; then
        echo "$AUTOSTARTCONF doesn't exist, creating..." 

        mkdir $AUTOSTARTCONF
        sudo chmod 777 $AUTOSTARTCONF
    fi

    echo "Symlinking $STARTUPCOMM into $AUTOSTARTCONF"
    printf "\n"
    ln -sfv $STARTUPCOMM $AUTOSTARTCONF
    printf "\n"

    echo "Changing ownership..."
    sudo chown -h $USER:$USER "$AUTOSTARTCONF/tilix-monitor.desktop" -v
    printf "\n"
}

tilixDefaults
