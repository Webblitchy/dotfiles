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

autocmd BufEnter * silent! lcd %:p:h " automatically set vim path to current dir

" ############## BEHAVOURS #############

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

set backspace=indent,eol,start  " more powerful backspacing

set autoread              " Automatically reload changes if detected

set mouse=a

set belloff=all           " Disable error bell

" Recherche
set ignorecase            " Case insensitive search
set smartcase             " Sensible to capital letters
set incsearch             " Show search results as you type
"set hlsearch              " Highlight search results
"nnoremap <silent> <CR> :noh<CR><CR>" Disable highlight when pressing enter again


" Persistent undo (le dossier doit exister)
set undodir=~/.vim/undodir/
set undofile
set undolevels=1000
set undoreload=10000

set history=1000                     " Command history

set nobackup writebackup

set noswapfile " disable the swapfile
   " Timeout before a command key stop waiting
set timeoutlen=500    " Timeout before a command key stop waiting
set ttimeoutlen=0     " Remove timeout when hitting escape (ex: V-mode)

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

let g:gruvbox_italic=1 " active l'italique (p.ex pour les commentaires)
" active le thème gruvbox
colorscheme gruvbox

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
set listchars=extends:→               " Show arrow if line continues rightwards
set listchars+=precedes:←             " Show arrow if line continues leftwards
set listchars+=tab:▸\
set listchars+=trail:·

" Color current line number
hi CursorLineNr guifg=#fe8019 " gruvbox light orange
set cursorline
set cursorlineopt=number


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
inoremap <C-c> <Esc>" to make ctrl-c behave exactly like esc
nnoremap <C-c> <Esc>" to make ctrl-c behave exactly like esc
vnoremap <C-c> <Esc>" to make ctrl-c behave exactly like esc


" CTRL-BS for delete previous word (set char with CTRL-v + CTRL-BS)
inoremap  <C-W>

" Use default FZF for file search
nmap <C-P> :FZF<CR>


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

" ######### PLUGINS ########
" ### Airline parameters
let g:airline_theme='base16_gruvbox_dark_hard' " installer airline-themes
let g:airline_powerline_fonts = 1 " activer les caratères fleches
let g:airline#extensions#tabline#enabled = 1 " afficher les buffer comme des onglets
let g:airline#extensions#whitespace#enabled = 0 " disable trailing count in the bar
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]' " hide encoding when default
" Set tabs as vertical lines
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"Set downsection
let g:airline_section_z = airline#section#create_right(['%3p%%','L:%3l/%L','C:%3v']) " format char counter in the bar

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
" Coc navigation
nnoremap <silent> cy <Plug>(coc-type-definition)
nnoremap <silent> ci <Plug>(coc-implementation)
nnoremap <silent> cr <Plug>(coc-references)
nnoremap <leader>rn <Plug>(coc-rename)

" Nerd tree
nnoremap <C-t> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$']
nnoremap <C-f> :NERDTreeFind<CR>
