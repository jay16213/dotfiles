#!/bin/bash

print_help () {
    echo "Usage: $0 [-f] [-h]"
    echo ""
    echo "  -f    install additional font (will install Ubuntu Mono Nerd Font from https://github.com/ryanoasis/nerd-fonts)"
    echo "  -h    show help message"
}

install_fonts=false # do not install fonts by default

while getopts "fh" opt; do
    case ${opt} in
        f)
            install_fonts=true
            ;;
        h)
            print_help
            exit
            ;;
        \?)
            print_help
            exit 1
            ;;
    esac
done

sudo apt-get update

# install dependencies
sudo apt-get -y install git curl zsh fontconfig

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# install zsh theme "powerlevel9k"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# backup original zshrc
if [ -f "$HOME/.zshrc" ]; then
    cp $HOME/.zshrc $HOME/.zshrc-old
fi

# copy zshrc
cp zshrc $HOME/.zshrc

# use P9KGT to config powerlevel9k: https://github.com/Powerlevel9k/powerlevel9k/wiki/Show-Off-Your-Config
# source for P9KGT: https://github.com/lucatrv/dotfiles
cp zshrc_P9KGT $HOME/.zshrc_P9KGT

# install additional fonts
if [ $install_fonts = true ]; then
    echo "Start install Ubuntu Mono Nerd Font..."

    # install Ubuntu Mono Nerd Font from https://github.com/ryanoasis/nerd-fonts
    unzip UbuntuMono.zip -d UbuntuMono

    # move fonts to $HOME/.font directory
    if [ ! -f "$HOME/.fonts" ]; then
        mkdir -p $HOME/.fonts
    fi

    cp UbuntuMono/* $HOME/.fonts/

    # rebuild the font cache
    fc-cache -f -v

    # delete nerd-fonts directory after installing the font
    rm -rf UbuntuMono
    echo "install done"
fi

# change default shell to zsh
chsh -s /bin/zsh

echo "Remember login again to reload default shell settings"

if [ $install_fonts = true ]; then
    echo "And change terminal font to \"UbuntuMono Nerd Font Regular\""
fi
