#!/bin/bash
# Move to Home directory
cd ~
# Unlink existing .zshrc and .ideavimrc and backup real files
if [ -L .zshrc ]; then
    unlink .zshrc 
elif [ -f .zshrc ]; then
    mv .zshrc .zshrc.bak 
fi
if [ -L .ideavimrc ]; then
    unlink .ideavimrc
elif [ -f .ideavimrc ]; then
    mv .ideavimrc .ideavimrc.bak
fi
# Create new symbolic links
ln -s ~/dotfiles/.zshrc .zshrc
ln -s ~/dotfiles/.ideavimrc .ideavimrc
