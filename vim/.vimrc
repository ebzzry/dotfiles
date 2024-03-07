syntax enable

set laststatus=0
set cmdheight=1
set background=dark
set guioptions=aiMr
set ignorecase
set number

nnoremap jk <esc>         " Remap in Normal mode
inoremap jk <esc>         " Remap in Insert and Replace mode
vnoremap jk <esc>         " Remap in Visual and Select mode
xnoremap jk <esc>         " Remap in Visual mode
snoremap jk <esc>         " Remap in Select mode
cnoremap jk <C-C>         " Remap in Command-line mode
onoremap jk <esc>         " Remap in Operator pending mode
