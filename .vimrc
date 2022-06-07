"
" Command W : save as root (when file is not open as it)
" (custom by Eliott)
"
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" active le thème gruvbox
autocmd vimenter * ++nested colorscheme gruvbox

" appliquer les couleurs pour la syntaxe
syntax on

" afficher le no de ligne
:set number  " Affiche le numéro de la ligne actuelle
:set relativenumber  " Affiche le numéro relatif à la ligne actuelle

" Utilisation de 4 tabs à la place du tab
set shiftwidth=4    " Indents will have a width of 4.
set softtabstop=4   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.
set tabstop=4       " The width of a TAB is set to 4. Still it is a \t. It is just that Vim will interpret it to be having a width of 4


