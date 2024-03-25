#!/bin/bash

print_help () {
    echo "Usage: $0 [-f] [-h]"
    echo ""
    echo "  -f    install additional font (will install Meslo Nerd Font which is recommended by powerlevel10k)"
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

# Install dependencies
sudo apt-get update
sudo apt-get -y install git curl zsh fontconfig

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh theme "powerlevel10k": https://github.com/romkatv/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

# Backup original zshrc and .p10k.zsh
if [ -f "$HOME/.zshrc" ]; then
    cp $HOME/.zshrc $HOME/.zshrc.bak
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    cp $HOME/.p10k.zsh $HOME/.p10k.zsh.bak
fi

# Copy zshrc and .p10k.zsh
cp zshrc $HOME/.zshrc
cp .p10k.zsh $HOME/.p10k.zsh

# Install fonts for powerlevel10k
if [ $install_fonts = true ]; then
    echo "Start install Meslo Nerd Font..."

    # install Meslo Nerd Font from https://github.com/romkatv/powerlevel10k
    unzip meslo-nerd-font.zip -d meslo-nerd-font

    # move fonts to $HOME/.font directory
    if [ ! -f "$HOME/.fonts" ]; then
        mkdir -p $HOME/.fonts
    fi

    cp meslo-nerd-font/* $HOME/.fonts/

    # rebuild the font cache
    fc-cache -f -v

    # delete nerd-fonts directory after installing the font
    rm -rf meslo-nerd-font
    echo "Install Meslo Nerd Font done, remember change the terminal font to \"MesloLGS NF Regular\""
fi


# Change default shell to zsh, ignore this part for Github Codespaces
# See reference: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces#troubleshooting-dotfiles
if [ $CODESPACES = false ]; then
    chsh -s /bin/zsh
    echo "Remember login again to reload default shell settings"
fi
