#!/bin/bash
# Move to Home directory
cd ~
# Backup and remove existing .zshrc and .ideavimrc
if [ -f .zshrc ]; then
    mv .zshrc .zshrc.bak 
fi
if [ -f .ideavimrc ]; then
    mv .ideavimrc .ideavimrc.bak
fi
# Create new symbolic links
ln -s ~/dotfiles/.zshrc .zshrc
ln -s ~/dotfiles/.ideavimrc .ideavimrc
