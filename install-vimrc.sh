#!/bin/bash

# copy vimrc to $HOME directory
cp ./vimrc $HOME/.vimrc

# install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

# install vim plugins
vim +PluginInstall +qall

