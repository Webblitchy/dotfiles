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

" ######## FILE FORMATS #######
set encoding=utf-8
scriptencoding utf-8
set fileformat=unix

" ###### BEFORE ALL #####
let mapleader = "-" " Define leader key
autocmd BufEnter * silent! lcd %:p:h " automatically set vim path to current dir

" ############## PLUGIN INSTALLATION ###############

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif


call plug#begin('~/.vim/plug-plugins')
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'  " show git branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ap/vim-css-color'  " highlight hex color text to the right color
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
"sudo npm i -g bash-language-server    => coc for bash

call plug#end()

" Plug commands
"PlugInstall -> to run on first launch
"PlugUpdate
"PlugStatus
"PlugClean
"PlugUpgrade

" ############## BEHAVOURS #############

" KEYS BEHAVOURS

set backspace=indent,eol,start  " more powerful backspacing

" To use mouse only for resizing windows (make Ctrl-Shift-c not working)
" set mouse=a
" nnoremap <LeftMouse> m'<LeftMouse>
" nnoremap <LeftRelease> <LeftRelease>g``
" inoremap <LeftMouse> <ESC>m'i<LeftMouse>
" inoremap <LeftRelease> <LeftRelease><ESC>g``a

" Indentation settings
set autoindent " always set autoindenting on
set copyindent " copy the previous indentation on autoindenting
set expandtab " expand tabs to spaces 
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4 " number of spaces to use for autoindenting
set smartindent
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop
set softtabstop=4 " when hitting <BS>, pretend like a tab is removed, even if spaces
set tabstop=4 " tabs are n spaces 


" Timeout before a command key stop waiting
set timeoutlen=500    " Timeout before a command key stop waiting
set ttimeoutlen=0     " Remove timeout when hitting escape (ex: V-mode)

set autoread              " Automatically reload changes if detected


set belloff=all           " Disable error bell

" SEARCH
set ignorecase            " Case insensitive search
set smartcase             " Sensible to capital letters
set incsearch             " Show search results as you type
"set hlsearch              " Highlight search results
"nnoremap <silent> <CR> :noh<CR><CR>" Disable highlight when pressing enter again

" HISTORY
" Persistent undo (le dossier doit exister)
set undodir=~/.vim/undodir/
set undofile
set undolevels=1000
set undoreload=10000

set history=1000                     " Command history

set nobackup writebackup

set noswapfile " disable the swapfile

set clipboard=unnamedplus " use system clipboard as the main clipboard

" ##### :command auto completion #####
" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.xlsx,*.bin

" set the inner terminal to be zsh
set shell=/bin/zsh
set shellcmdflag=-ci " uses .zshrc

set confirm " prompt for saving instead of error

" ############### UI ###############

" appliquer les couleurs pour la syntaxe
syntax on
set termguicolors " afficher les bonnes couleurs

set title " display file name on window title
set showcmd " afficher les compositions de lettre en direct

if isdirectory( expand("$HOME/.vim/plug-plugins/gruvbox") )
    let g:gruvbox_italic=1 " active l'italique (p.ex pour les commentaires)
    let g:gruvbox_bold=1
    " active le thème gruvbox
    colorscheme gruvbox
endif

hi Normal guibg=NONE ctermbg=NONE   " transparent background

" afficher le no de ligne
set number  " Affiche le numéro de la ligne actuelle
set relativenumber  " Affiche le numéro relatif à la ligne actuelle

set showmatch                         " Show matching brackets
set matchpairs=(:),{:},[:],<:>

" keep lines under cursor
function! SetAutoScrolloff()
    let quarterOfHeight = winheight(0) / 3
    execute ':set scrolloff=' . quarterOfHeight
endfunction
autocmd! VimResized,VimEnter,WinEnter,WinLeave * call SetAutoScrolloff()

set list                              " Sinon les listschars ne fonctionnent pas
" Invisible char and their representation
set listchars=extends:→               " Show arrow if line continues rightwards
set listchars+=precedes:←             " Show arrow if line continues leftwards
set listchars+=tab:⊦—▸
set listchars+=trail:·

" Color current line number
hi CursorLineNr guifg=#fe8019 " gruvbox light orange
set cursorline
set cursorlineopt=number

" Enable color highlighting inside markdown code blocs
let g:markdown_fenced_languages = ['python', 'cpp', 'c', 'java', 'rust', 'bash', 'css', 'js=javascript', 'html']

" Change the cursor lenght in function of the mode (VTE compatible terminals)
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

function! SetupEnvironment()
    "Restore cursor position
    if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Set wrapping/textwidth according to type
    if (&ft == 'markdown' || &ft == 'text' || &ft == 'html')
        setlocal wrap
    else
        " default textwidth slightly narrower than the default
        setlocal nowrap
    endif
endfunction
autocmd! BufReadPost,BufNewFile * call SetupEnvironment()


" Remove the ugly splits separator
set fillchars=vert:\│
hi VertSplit term=NONE cterm=NONE gui=NONE ctermfg=DarkGrey


" automatically create the folder if not already exists
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END



" ############ COMMANDS ############
" Command W : save as root (when file is not open as it)
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!



" ################ REMAPS / SHORTCUTS ################
inoremap <silent> <Esc> <Esc>:echo "=> Use ctrl-c"<CR><Esc>:startinsert<CR>

" to make ctrl-c behave exactly like esc
inoremap <C-c> <Esc>
nnoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" to make TAB rotate between all buffers
nnoremap <silent> <TAB> :bn<CR>

" close buffer with --
nnoremap <silent> <leader>- :bd<CR>

" CTRL-BS for delete previous word (set char with CTRL-v + CTRL-BS)
inoremap  <C-W>



" register macro with qq and play it with Q
nnoremap Q @q

" use Y with the same logic as C and D
nnoremap Y y$

" Navigate easily between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Resize easily windows
map <s-LEFT> :vertical resize +5 <Cr>
map <s-RIGHT> :vertical resize -5 <Cr>
map <s-UP> :resize +5 <Cr>
map <s-DOWN> :resize -5 <Cr>


" ######### PLUGINS SETTINGS ########
" ### Airline parameters
if isdirectory( expand("$HOME/.vim/plug-plugins/vim-airline"))
    let g:airline_theme='base16_gruvbox_dark_hard' " installer airline-themes
    let g:airline_powerline_fonts = 1 " activer les caratères fleches
    let g:airline#extensions#tabline#enabled = 1 " afficher les buffer comme des onglets
    let g:airline#extensions#whitespace#enabled = 0 " disable trailing count in the bar
    "let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " hide encoding when default
    let g:airline#extensions#wordcount#enabled = 0
    let g:airline#extensions#branch#enabled=1
    " Set tabs as vertical lines
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    "Set downsection
    let g:airline_section_z = airline#section#create_right(['%3p%%',':%3l/%L',':%3v']) " format char counter in the bar
endif

" indirectement lié (cache barre de status originale)
set noshowmode " hide mode (not directly related to airline)
set shortmess+=F  " to get rid of the file name displayed in the command line bar
set shortmess+=c  " get rid of the 'match 1 of 2' in the command line bar

" ### coc.nvim
" More examples : https://github.com/neoclide/coc.nvim#example-vim-configuration

" handle these types of files
let g:coc_global_extensions = ['coc-git', 'coc-json', 'coc-clangd', 'coc-java', 'coc-css', 'coc-pyright', 'coc-html', 'coc-tsserver', 'coc-rls']
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
" Coc navigation
nnoremap <silent> cy <Plug>(coc-type-definition)
nnoremap <silent> ci <Plug>(coc-implementation)
nnoremap <silent> cr <Plug>(coc-references)
nnoremap <leader>rn <Plug>(coc-rename)

" Nerd tree
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
let NERDTreeRespectWildIgnore=1
set wildignore+=*.git,*.jpg,*.mp4,*.ogg,*.iso,*.pdf,*.pyc,*.odt,*.png,*.gif
let NERDTreeShowHidden=1

" Commentary
" (use Ctrl-7)
xmap  gc
nmap  gc
omap  gc
nmap  gcc

" set comment style to // for c(++) and java
autocmd FileType c,cpp,java setlocal commentstring=//\ %s

" FZF

" Use vim FZF for file search
nmap <C-P> :Files ~<CR>

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
" Display nicely document preview in fzf
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
"   -> INSTALL bat and add "export BAT_THEME="gruvbox-dark"" to .zshrc
