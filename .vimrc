" VIMRC 

set encoding=utf-8
scriptencoding utf-8

" ############ COMMANDS ############
" Command W : save as root (when file is not open as it)
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" ############## BEHAVOURS #############
" Utilisation de 4 tabs à la place du tab
set autoindent " always set autoindenting on
set copyindent " copy the previous indentation on autoindenting
set expandtab " expand tabs to spaces 
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4 " number of spaces to use for autoindenting
set smartindent
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop
set softtabstop=4 " when hitting <BS>, pretend like a tab is removed, even if spaces
set tabstop=4 " tabs are n spaces 

" Display filename in window name (Konsole)
silent !echo -en $"\033]30;%:t\007" 

set autoread              " Automatically reload changes if detected

" Recherche
set ignorecase            " Case insensitive search
set hlsearch              " Highlight search results
nnoremap <esc> :noh<return><esc> " stop highlighting when pressing ESC
set incsearch             " Show search results as you type

" Persistent undo (le dossier doit exister)
set undodir=~/.vim/undodir/
set undofile
set undolevels=1000
set undoreload=10000

set timeoutlen=1000 ttimeoutlen=0     " Remove timeout when hitting escape (ex: V-mode)

" ############### UI ###############

" appliquer les couleurs pour la syntaxe
syntax on

" active le thème gruvbox
"autocmd vimenter * ++nested colorscheme gruvbox " Empeche l'italic
colorscheme gruvbox

" Showcase comments in italics
highlight Comment cterm=italic gui=italic

" afficher le no de ligne
set number  " Affiche le numéro de la ligne actuelle
set relativenumber  " Affiche le numéro relatif à la ligne actuelle

set showmatch             " Show matching brackets


set nowrap                            " Don't wrap long lines
set list                              " Sinon les listschars ne fonctionnent pas
set listchars=extends:→               " Show arrow if line continues rightwards
set listchars+=precedes:←             " Show arrow if line continues leftwards
set listchars+=tab:▸\ 
set listchars+=trail:·

