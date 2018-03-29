runtime! debian.vim

" General
set nocompatible
set encoding=utf-8
set nobackup " annoyances
set nowritebackup " annoyances
set noswapfile " annoyances
set noerrorbells " annoyances
set novisualbell " annoyances
set fileformats=unix,mac,dos " handle dos and mac but prefer unix
set hidden " allow hiding buffers with unsaved changes
set wildmenu " command-line completion enhanced mode
set wildmode=list:longest,full
set backspace=indent,eol,start " better backspace
set autowrite " write changes before make/shell commands
set autoread " reload when external changes detected
set history=256 " command history
set timeoutlen=300 " timeout for key command sequences
set viminfo=h,'500,<10000,s1000,/1000,:1000 " :help viminfo
set dictionary+=/usr/share/dict/words
set complete+=k " add dictionary scanning
syntax on
filetype plugin indent on

" Searching
set incsearch
set hlsearch
set ignorecase
set smartcase
set gdefault " replace (s///g) defaults to global
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,.DS_Store,*.aux,*.out,*.toc,tmp,*.scssc
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Indenting / formating
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab " tabs to spaces
set smarttab
set list lcs=tab:\►\ ,trail:·,precedes:«,extends:»
set nowrap " no soft-wrapping
set textwidth=0 " no hard-wrapping
" File spesific rules
autocmd Filetype ruby setlocal ts=2 sw=2
autocmd Filetype eruby setlocal ts=2 sw=2
autocmd VimEnter COMMIT_EDITMSG setlocal filetype=gitcommit
autocmd Filetype mail,gitcommit,gitsendemail setlocal textwidth=72 spell

" Visual
colorscheme delek
if has("gui_running")
    colorscheme codeschool
    set guioptions-=T
    set guioptions+=b
    set lines=80
    set columns=200
endif
set guifont=Monospace\ 8
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set number " line numbers
set ruler " cursor position
set showmatch " show matching brackets
set matchtime=0 " blink time for brackets
set laststatus=2 " always show status line.
set scrolloff=3 " lines under/above cursor
set showcmd " show commandline
set mouse-=a " mouse defaults off

" Plugins via. vim-plug
call plug#begin('~/.vim/plugged')
    " Simple stuff
    Plug 'tpope/vim-sensible' " community defaults
    Plug 'tomasr/molokai' " colortheme
    Plug 'nvie/vim-togglemouse' " toggle mouse command
    Plug 'jordwalke/VimAutoMakeDirectory' " create dirs when needed 
    Plug 'Yggdroot/indentLine' " vertical indentation lines
    Plug 'ntpeters/vim-better-whitespace' " highlight wrong whitespace
    " Simple++
    Plug 'yegappan/grep' " [R|F|E|A]grep commands
    Plug 'scrooloose/nerdcommenter' " commenting commands
    Plug 'tpope/vim-fugitive' " :G-Git commands
    " Medium
    Plug 'troydm/easybuffer.vim' " easy buffer list
    Plug 'scrooloose/nerdtree' " tree file explorer
    Plug 'majutsushi/tagbar' " code structure overview
    Plug 'kien/ctrlp.vim' " Ctrl+P fuzzy-finder
    " Heavy
    Plug 'bling/vim-airline' " powerline status-bar for vim
    "Plug 'garbas/vim-snipmate' " automatic code snippets
    Plug 'tpope/vim-rails', { 'for': 'ruby' }
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'klen/python-mode', { 'for': 'python' }
    " Old
    "Plug 'dahu/VimGym'
    "Plug 'scrooloose/syntastic'
    "Plug 'vim-scripts/bufexplorer.zip'
    "Plug 'wincent/command-t'
    "Plug 'ciaranm/detectindent'
    "Plug 'lornix/vim-scrollbar'
    "Plug 'Shougo/neocomplcache.vim'
    "Plug 'edkolev/tmuxline.vim'
call plug#end()

" Plugin settings / mappings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
let g:indentLine_enabled = 0
let g:indentLine_leadingSpaceChar = '·'
"let g:better_whitespace_enabled = 0
map <C-n> :NERDTreeToggle<CR><F12><CR> " F12 via vim-togglemouse
map <C-c> :TagbarToggle<CR>
map <C-b> :EasyBuffer<CR>
map <F9> :IndentLinesToggle<CR>:LeadingSpaceToggle<CR>:ToggleWhitespace<CR>:call g:ToggleColorColumn()<CR>

" Key mappings

" single-key command and leader for ISO-layout
map . :
map , <Leader>
" map <Space> :
" map <CR> <Leader>

" better ESC
inoremap <C-k> <Esc>

" inverse tabs with shift
imap <S-Tab> <Esc><<i

" shortcut for paste-mode
noremap <F11> :set paste!<CR>
" togglepaste=<F11>

" shortcut for :%s/.../.../g
nmap S :%s//g<LEFT><LEFT>
vmap S :B s//g<LEFT><LEFT>

" fast swapping between buffers
map <Leader>n :bn<CR>
map <Leader>p :bp<CR>
map <Leader>g :b#<CR>
map <Leader>t :enew<CR>
map <leader>q :bp <BAR> bd #<CR>
map <leader>b :CtrlPBuffer<CR>
map <C-Tab>   :bn<CR>
map <C-S-Tab> :bp<CR>
map <Leader>1 :1b<CR>
map <Leader>2 :2b<CR>
map <Leader>3 :3b<CR>
map <Leader>4 :4b<CR>
map <Leader>5 :5b<CR>
map <Leader>6 :6b<CR>
map <Leader>7 :7b<CR>
map <Leader>8 :8b<CR>
map <Leader>9 :9b<CR>
map <Leader>0 :10b<CR>

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv

" clear highlight after search
noremap <silent><Leader>/ :nohls<CR>

" emacs bindings in command line mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" easy splitted window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" quick editing
nnoremap <leader>eg <C-w>s<C-w>j:e ~/.gitconfig<cr>
nnoremap <leader>ez <C-w>s<C-w>j:e ~/.zshrc<cr>
nnoremap <leader>eb <C-w>s<C-w>j:e ~/.bashrc<cr>
nnoremap <leader>et <C-w>s<C-w>j:e ~/.tmux.conf<cr>

" Short vim-scripts

" remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" write using sudo
comm! W exec 'w !sudo tee % > /dev/null' | e!

" backup the current file
nmap BB :!bak -q %<CR><CR>:echomsg "Backed up" expand('%')<CR>

" subtle colorcolumn for 256 color terminals
if (&t_Co =~ '256')
    " let &colorcolumn="80,100,".join(range(120,999),",")
    set colorcolumn=80,120
    highlight ColorColumn ctermbg=232
endif

" set the screen/tmux hardstatus to vim(filename.ext)
if (&term =~ '^screen')
    set t_ts=k
    set t_fs=\
    set title
    autocmd BufEnter * let &titlestring = "vim(" . expand("%:t") . ")"
    let &titleold = fnamemodify(&shell, ":t")
endif

function! g:ToggleColorColumn()
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=80,120
        highlight ColorColumn ctermbg=darkgray
    endif
endfunction
