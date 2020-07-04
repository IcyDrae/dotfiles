#!/bin/bash

copyBashRc() {
    BASHRC="$PWD/.bashrc"
    
    echo "Copying .bashrc into user directory..."
    cp $BASHRC ~/
    echo "Sourcing new .bashrc"
    source ~/.bashrc
}

echo "Running copyBashRc"
copyBashRc
echo "end"

