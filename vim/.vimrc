set number
set laststatus=2
set wrap
set encoding=utf-8

" Plug file
if filereadable(expand("~/.vimrc.plug"))
    source ~/.vimrc.plug
endif

" VIMWiki settings
set nocompatible
filetype plugin on
syntax on

" Colors follow pywal: wal.vim uses the 16 terminal colors, which alacritty
" already takes from wal, so palette changes apply without a reload.
silent! colorscheme wal
let g:airline_theme = 'wal'
