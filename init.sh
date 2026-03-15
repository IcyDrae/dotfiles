#!/bin/bash

# ----------------------------------------
# init.sh - Copy setup files into $HOME
# ----------------------------------------

# Exit on error
set -e

# Ensure directories exist
mkdir -p ~/.ssh
mkdir -p ~/.config/alacritty

# Copy files
cp --verbose .bashrc ~/.bashrc
cp --verbose .ssh/config ~/.ssh/config
cp --verbose git/.gitconfig ~/.gitconfig
cp --verbose alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml 

# Fix permissions for SSH
chmod 600 ~/.ssh/config

echo "All files copied successfully!"

