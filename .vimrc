let mapleader=","
set tabstop=4
set shiftwidth=4
set expandtab
set nu
xmap < <gv
xmap > >gv

nmap <silent> <Leader>h :call TreeOpenFocus()<CR>
nmap <silent> <Leader>H :NERDTreeToggle<CR>
nmap <silent> <Leader>d :Bclose<CR>
nmap <silent> <Leader>D :Bclose!<CR>

let g:buftabs_active_highlight_group = "Visual"
let g:buftabs_in_statusline = 1
let g:buftabs_only_basename = 1
nmap <silent> <C-h> :bprev<CR>
nmap <silent> <C-l> :bnext<CR>


function! TreeOpenFocus()
    let wnr = bufwinnr("NERD_tree_1")
    if wnr == -1
        :NERDTreeToggle
    else
        exec wnr."wincmd w"
    endif
endfunction



colorscheme evening


" TeX
au FileType tex,plaintex set tw=80
au BufNewFile,BufRead *.tex set ft=tex

set ai

" Accept vim settings in files
set modeline

set hidden

nmap <silent> <Leader>d :Bclose<CR> 
nmap <silent> <Leader>D :Bclose!<CR> 

set showcmd
set laststatus=2

if $TERM == 'linux'
    " Virtual Console
    colorscheme delek
else
    " Color terminal
    set t_Co=256
    colorscheme customleo
endif

" Swap ` and '
noremap ' `
noremap ` '

" Use UTF-8 encoding
set encoding=utf-8

" Put swapfiles in central directory
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Characters to use in list mode
set listchars=tab:│\ ,trail:·
set list

" Show search match while typing
set incsearch

" Show line and column number
set number
set ruler

" Show matching brackets when typed
set showmatch

" Number of lines from the edge to scroll
set scrolloff=5

" Highlight matches on a search
set hls

" Highlight syntax
syntax on

" Global match by default
set gdefault

" Smart case insensitive search
set ignorecase
set smartcase

" Allow backspacing over more items
set backspace=indent,eol,start

set pastetoggle=<F10>

nmap <left> <C-w>h
nmap <right> <C-w>l
nmap <up> <C-w>k
nmap <down> <C-w>j
