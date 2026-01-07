#!/bin/bash
set -e

print_help () {
    cat <<EOF
Usage: $(basename "$0") [-f] [-h]

  -f    install additional font (Meslo Nerd Font recommended by powerlevel10k)
  -h    show help message
EOF
}

install_fonts=false

while getopts "fh" opt; do
    case ${opt} in
        f) install_fonts=true ;;
        h) print_help; exit 0 ;;
        *) print_help; exit 1 ;;
    esac
done

# Detect OS
OS_TYPE="$(uname -s)"
IS_MAC=false
IS_LINUX=false
if [[ "$OS_TYPE" == "Darwin" ]]; then
    IS_MAC=true
elif [[ "$OS_TYPE" == "Linux" ]]; then
    IS_LINUX=true
fi

# Helper: run package installation according to OS
install_packages() {
    if $IS_LINUX; then
        echo "Detected Linux: installing apt packages..."
        sudo apt-get update
        sudo apt-get install -y git curl zsh fontconfig unzip
    elif $IS_MAC; then
        echo "Detected macOS: installing brew packages..."
        if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
        exit 1
        fi
        brew update
        brew install git curl zsh fontconfig unzip || true
    else
        echo "Unsupported OS: $OS_TYPE"
        exit 1
    fi
}

# Install oh-my-zsh if needed (unattended)
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "oh-my-zsh already installed"
    else
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# Install powerlevel10k theme
install_powerlevel10k() {
    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "powerlevel10k already installed"
    else
        echo "Installing powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi
}

# Backup and copy dotfiles
backup_and_copy_dotfiles() {
    timestamp="$(date +%Y%m%d%H%M%S)"
    if [ -f "$HOME/.zshrc" ]; then
        echo "Backing up existing .zshrc -> .zshrc.bak.$timestamp"
        cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$timestamp"
    fi
    if [ -f "$HOME/.p10k.zsh" ]; then
        echo "Backing up existing .p10k.zsh -> .p10k.zsh.bak.$timestamp"
        cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$timestamp"
    fi

    echo "Copying repository zshrc and .p10k.zsh to home"
    cp -f zshrc "$HOME/.zshrc"
    if [ -f .p10k.zsh ]; then
        cp -f .p10k.zsh "$HOME/.p10k.zsh"
    fi

    echo "Dotfiles copied"
}

# Parse plugins from ~/.zshrc and install any missing ones
install_plugins_from_zshrc() {
    echo "Installing plugins from .zshrc..."

    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    ZSH=${ZSH:-$HOME/.oh-my-zsh}

    # Extract plugins block from the installed .zshrc
    if ! grep -q '^plugins=' "$HOME/.zshrc"; then
        echo "No plugins found in .zshrc"
        return
    fi

    echo "Found plugins in .zshrc:"

    # Get contents between plugins=( and )
    plugins_block=$(sed -n '/^plugins= *(/,/)/p' "$HOME/.zshrc" | sed '1s/.*(//;$s/).*//')
    # Normalize to lines (safe, non-blocking splitting)
    # Disable globbing to avoid accidental filename expansion
    set -f
    plugins_array=()
    oldIFS=$IFS
    IFS=$' \t\n'
    for p in $plugins_block; do
        plugins_array+=("$p")
    done
    IFS=$oldIFS
    set +f

    for plugin in "${plugins_array[@]}"; do
        # remove comments and whitespace
        plugin=${plugin%%#*}
        plugin=${plugin//[$' \t\n\r']/}
        [ -z "$plugin" ] && continue

        # Skip if already present in core plugins
        if [ -d "$ZSH/custom/plugins/$plugin" ] || [ -d "$ZSH/plugins/$plugin" ]; then
        echo "Plugin '$plugin' already available"
        continue
        fi

        echo "Installing plugin: $plugin"
        # Try common locations
        cloned=false
        if git ls-remote "https://github.com/zsh-users/$plugin.git" >/dev/null 2>&1; then
        git clone --depth=1 "https://github.com/zsh-users/$plugin.git" "$ZSH_CUSTOM/plugins/$plugin" && cloned=true
        elif git ls-remote "https://github.com/ohmyzsh/$plugin.git" >/dev/null 2>&1; then
        git clone --depth=1 "https://github.com/ohmyzsh/$plugin.git" "$ZSH_CUSTOM/plugins/$plugin" && cloned=true
        else
        echo "Could not find remote repo for plugin '$plugin' in zsh-users/ or ohmyzsh/ — skipping automatic install"
        fi

        if $cloned; then
        echo "Installed plugin '$plugin'"
        fi
    done

    echo "Plugin installation from .zshrc completed."
}

install_fonts() {
    if ! $install_fonts; then
        return
    fi

    echo "Installing Meslo Nerd Font..."

    if $IS_MAC; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        brew install font-hack-nerd-font
        echo "Installed Meslo fonts via Homebrew. Set your terminal font to 'MesloLGS NF Regular'."
    elif $IS_LINUX; then
        tmpdir="$(mktemp -d)"
        trap 'rm -rf "$tmpdir"' EXIT
        # Try to download latest Meslo from Nerd Fonts release
        if curl -fSL -o "$tmpdir/meslo.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"; then
        unzip -q "$tmpdir/meslo.zip" -d "$tmpdir/meslo"
        mkdir -p "$HOME/.local/share/fonts"
        cp "$tmpdir/meslo"/* "$HOME/.local/share/fonts/" || true
        fc-cache -f -v || true
        echo "Installed Meslo fonts to $HOME/.local/share/fonts. Set your terminal font to 'MesloLGS NF Regular'."
        else
        echo "Failed to download Meslo from nerd-fonts releases. Please install fonts manually."
        fi
    fi
}

change_default_shell() {
    # Do not change shell in Codespaces or if CODESPACES env var is set to 'true'
    # See reference: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces#troubleshooting-dotfiles
    if [ "${CODESPACES:-}" = "true" ]; then
        echo "Detected Codespaces — skipping chsh"
        return
    fi

    zsh_path="$(command -v zsh || true)"
    if [ -z "$zsh_path" ]; then
        echo "zsh not found, skipping chsh"
        return
    fi

    current_shell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7 || echo $SHELL)"
    if [ "$current_shell" = "$zsh_path" ]; then
        echo "Default shell already zsh"
        return
    fi

    echo "Changing default shell to $zsh_path ..."

    if chsh -s "$zsh_path" "$USER"; then
        echo "Default shell changed to zsh. Please log out and back in to see changes."
    else
        echo "Unable to change default shell automatically. You can run: chsh -s $zsh_path"
    fi
}

main() {
    install_packages
    install_oh_my_zsh
    install_powerlevel10k
    backup_and_copy_dotfiles
    install_plugins_from_zshrc
    install_fonts
    # disable change_default_shell for now
    # change_default_shell
    echo "\n Setup finished. Restart your terminal or log out and back in for changes to take effect."
}

main
