#!/bin/bash

sudo apt-get update

# install dependencies
sudo apt-get install git curl zsh

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh theme "powerlevel9k"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# backup original zshrc
cp $HOME/.zshrc $HOME/.zshrc-old

# copy zshrc
cp .zshrc $HOME/

# use P9KGT to config powerlevel9k: https://github.com/Powerlevel9k/powerlevel9k/wiki/Show-Off-Your-Config
# source for P9KGT: https://github.com/lucatrv/dotfiles
cp .zshrc_P9KGT $HOME/

# install Ubuntu Mono Nerd Font from https://github.com/ryanoasis/nerd-fonts
cd $HOME
git clone https://github.com/ryanoasis/nerd-fonts.git
cd $HOME/nerd-fonts
./install.sh UbuntuMono

# delete nerd-fonts directory after installing the font
cd $HOME
rm -rf nerd-fonts

# change default shell to zsh
chsh -s /bin/zsh
