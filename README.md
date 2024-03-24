# dotfiles
My dotfiles, including zsh, vim, and git

## Usage

### Setup zsh, oh-my-zsh and powerlevel10k
Use `install.sh` to install [oh-my-zsh](https://ohmyz.sh/) and [powerlevel10k](https://github.com/romkatv/powerlevel10k) to your system, and it will replace your `.zshrc` if it is already exists (the original `.zshrc` will be renamed to `.zshrc.bak`)
```bash
./install.sh
```

If you have no any powerline font installed, you can use the `-f` option to install Meslo Nerd Font, which is the recommended font by powerlevel10k

```bash
./install.sh -f
```

### Setup Vim
install [Vundle.vim](https://github.com/VundleVim/Vundle.vim.git) and setup `.vimrc`, it would also install packages defined in `.vimrc` automatically

```bash
./install-vimrc.sh
```
