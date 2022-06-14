""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                                    "
"              ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗               "
"              ██║   ██║██║████╗ ████║██╔══██╗██╔════╝               "
"              ██║   ██║██║██╔████╔██║██████╔╝██║                    "
"              ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║                    "
"               ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗               "
"                ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝               "
"                                                                    "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set encoding=utf-8
scriptencoding utf-8

let mapleader = "-" " Define leader key


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

set backspace=indent,eol,start  " more powerful backspacing

set autoread              " Automatically reload changes if detected

" Recherche
set ignorecase            " Case insensitive search
set smartcase             " Sensible to capital letters
set hlsearch              " Highlight search results
set incsearch             " Show search results as you type

" Persistent undo (le dossier doit exister)
set undodir=~/.vim/undodir/
set undofile
set undolevels=1000
set undoreload=10000

set history=1000                     " Command history

set nobackup writebackup

set timeoutlen=250 ttimeoutlen=0     " Remove timeout when hitting escape (ex: V-mode)

" Restore cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Use default FZF for file search
nmap <C-P> :FZF<CR>

" move among buffers with CTRL h and j
map <C-L> :bnext<CR>
map <C-H> :bprev<CR>

" ##### :command auto completion #####
" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.xlsx,*.bin




" ############### UI ###############

" appliquer les couleurs pour la syntaxe
syntax on
set termguicolors " afficher les bonnes couleurs

set showcmd " afficher les compositions de lettre en direct

let g:gruvbox_italic=1 " active l'italique (p.ex pour les commentaires)
" active le thème gruvbox
colorscheme gruvbox

" afficher le no de ligne
set number  " Affiche le numéro de la ligne actuelle
set relativenumber  " Affiche le numéro relatif à la ligne actuelle

set showmatch                         " Show matching brackets
set matchpairs=(:),{:},[:],<:>

set scrolloff=10                      " keep lines under cursor

set nowrap                            " Don't wrap long lines
set list                              " Sinon les listschars ne fonctionnent pas
set listchars=extends:→               " Show arrow if line continues rightwards
set listchars+=precedes:←             " Show arrow if line continues leftwards
set listchars+=tab:▸\
set listchars+=trail:·

" Color current line number
hi CursorLineNr guifg=#fe8019 " gruvbox light orange
set cursorline
set cursorlineopt=number


" Change la forme du curseur en fonction du mode (VTE compatible terminals)
" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

set splitright                        " Open new splits to the right
set splitbelow                        " Open new splits to the bottom

set shortmess=I                       " disable start message

set signcolumn=yes                     " Always have a sign and number columns
"set signcolumn=number                 " Fusion sign and number columns
hi SignColumn ctermbg=NONE guibg=NONE  " Sign column has same color as number column 


" ############ COMMANDS ############
" Command W : save as root (when file is not open as it)
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!



" ################ REMAPS ################

" Get off my lawn - helpful when learning Vim :)
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
inoremap <silent> <Esc> <Esc>:echo "=> Use ctrl-c"<CR><Esc>:startinsert<CR>

nnoremap <silent> <CR> :noh<CR><CR>" Disable highlight when pressing enter again


" ######### PLUGINS ########
" ### Airline parameters
let g:airline_theme='base16_gruvbox_dark_hard' " installer airline-themes
let g:airline_powerline_fonts = 1 " activer les caratères fleches
let g:airline#extensions#tabline#enabled = 1 " afficher les buffer comme des onglets

" indirectement lié (cache barre de status originale)
set noshowmode " hide mode (not directly related to airline)
set shortmess+=F  " to get rid of the file name displayed in the command line bar

" ### coc.nvim
" More examples : https://github.com/neoclide/coc.nvim#example-vim-configuration

" handle these types of files
let g:coc_global_extensions = ['coc-git', 'coc-json', 'coc-clangd', 'coc-java', 'coc-css', 'coc-pyright', 'coc-html', 'coc-tsserver', 'coc-sh', 'coc-rls']
" add 'coc-git' to show changes
" uninstall with :CocUninstall <name>

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Toggle plugin
function! CocToggle()
    if g:coc_enabled
        CocDisable
    else
        CocEnable
    endif
endfunction

" Call CocToggle() function :
command! Coc : call CocToggle() " :CocToggle
inoremap <C-@> : call CocToggle()<CR><Left> " ctrl-space (in insert mode)
nnoremap <C-@> : call CocToggle()<CR><Left> " ctrl-space (in normal mode)

" Nerd tree
nnoremap <C-t> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$']



