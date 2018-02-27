let mapleader=";"
nmap LE $
vnoremap ;y "+y
nmap ;p "+p
nmap ;q :q<CR>
nmap ;w :w<CR>
nmap ;WQ :wa<CR>:q<CR>
nmap ;Q :qa!<CR>
nnoremap nw <C-W><C-W>
nnoremap ;lw <C-W>l
nnoremap ;hw <C-W>h
nnoremap ;kw <C-W>k
nnoremap ;jw <C-W>j
nmap ;M %

autocmd BufWritePost $MYVIMRC source $MYVIMRC

set incsearch
set ignorecase
set nocompatible
set wildmenu

" vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'dikiaap/minimalist'
Plugin 'powerline/powerline'
Plugin 'nathanaelkane/vim-indent-guides'
call vundle#end()
filetype plugin indent on

set t_Co=256
syntax enable
syntax on
colorscheme minimalist

set laststatus=2
set number
set cursorline
set hlsearch
set nowrap
set guifont=YaHei\ Consolas\ Hybrid\ 16

filetype indent on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
:nmap <silent> ;i <Plug>IndentGuidesToggle
set foldmethod=syntax
"set foldmethod=indent
set nofoldenable

"set tags+=/usr/include/sys.tags

