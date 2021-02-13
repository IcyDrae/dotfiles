#!/bin/bash

read -p "Your GitHub username: " username
read -p "Your GitHub email address: " email

# Unset if there are any
git config --global --unset-all user.name
git config --global --unset-all user.email

git config --global user.name "$username" # If you want to have spaces between first & last name
git config --global user.email $email
git config --global core.autocrlf input
git config --global core.editor vim
git config --global auto.crlf false
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.cm "commit"
git config --global alias.st "status"
