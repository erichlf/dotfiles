" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" auto reload when saving
autocmd! bufwritepost .vimrc source %

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

set printoptions=duplex:long,syntax:y,number:y

let mapleader=","

set iskeyword+=:

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set background=dark

" turn bells off
set noerrorbells
set novisualbell
set vb t_vb=
" force save file which requires root permission
cmap w!! %!sudo tee > /dev/null %

" swap directory
set directory=$HOME/.vim/swap

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" store lots of :cmdline history
set history=1000

set showcmd " show incomplete cmds down the bottom
set showmode " show current mode down the bottom

set nu " show line numbers
set rnu " show relative line numbers

set textwidth=110 " line wrapping

nmap <C-Left> <C-w>h
nmap <C-Down> <C-w>j
nmap <C-Up> <C-w>k
nmap <C-Right> <C-w>l

" sloppy typing
command! Q q
command! W w

set clipboard=unnamed

" display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set incsearch " find the next match as we type the search
set hlsearch " highlight searches by default

set wrap " wrap lines
set linebreak " wrap lines at convenient points

if v:version >= 703
" undo settings
    set undodir=~/.vim/undofiles
    set undofile
endif

" default indent settings
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set shiftround
set smartcase
set autoindent
set smartindent
autocmd FileType make setlocal noexpandtab

" swap files have been quite annoying lately
set nobackup
set nowritebackup
set noswapfile

" folding settings
set foldmethod=indent " fold based on indent
set foldnestmax=3 " deepest fold is 3 levels
set nofoldenable " don't fold by default

set wildmode=list:longest " make cmdline tab completion similar to bash
set wildmenu " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.pdf,*.pyc,*.o,*.obj,*~,*.lo,*.lo.d " stuff to ignore when tab completing

set formatoptions-=o " don't continue comments when pushing o/O

" vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

" some stuff to get the mouse going in term
set mouse=a

" tell the term has 256 colors
set t_Co=256

" hide buffers when not displayed
set hidden

filetype plugin indent on

au BufNewFile,BufRead *.md set ft=md

" make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" map Q to something useful
noremap Q gq

" make Y consistent with C and D
nnoremap Y y$
