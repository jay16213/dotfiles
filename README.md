# dotfiles
My dotfiles, including zsh, vim, and git

## Usage

### Setup oh-my-zsh and powerlevel9k
Use `install.sh` to install [oh-my-zsh](https://ohmyz.sh/) & powerlevel9k to your system, and it will replace your `.zshrc` if it is already exists (the original `.zshrc` will be renamed to `.zshrc-old`)
```bash
./install.sh
```

If you have no any powerline font installed, you can use the `-f` option to install [Ubuntu Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts)

```bash
./install.sh -f
```

### Setup Vim
install [Vundle.vim](https://github.com/VundleVim/Vundle.vim.git) and setup `.vimrc`, it would also install packages defined in `.vimrc` automatically

```bash
./install-vimrc.sh
```
