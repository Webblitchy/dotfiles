-------------------------------------------------------------------------------------------
-- Basic vim settings
-------------------------------------------------------------------------------------------

vim.o.backspace = [[indent,eol,start]] -- more powerful backspace (suppress in insert)
vim.o.mouse = "" -- disable mouse
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.spelllang = { "en", "fr" } -- dictionnary used for spell check

-- Indentation settings
vim.o.autoindent = true -- always set autoindenting on
vim.o.copyindent = true -- copy the previous indentation on autoindenting
vim.o.breakindent = true -- Enable break indent
vim.o.expandtab = true -- expand tabs to spaces
vim.o.shiftround = true -- use multiple of shiftwidth when indenting with '<' and '>'
vim.o.smartindent = true
vim.o.smarttab = true -- insert tabs on the start of a line according to shiftwidth, not tabstop
vim.o.softtabstop = 4 -- when hitting <BS>, pretend like a tab is removed, even if spaces

-- Automatically set by vim-sleuth:
-- vim.o.shiftwidth = 4 -- number of spaces to use for autoindenting
-- vim.o.tabstop = 4 -- tabs are n spaces


-- History
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 10000
vim.o.undodir = vim.fn.expand("~/.config/nvim/undo//") -- to have all undos in the same dir (expand for tilde)
vim.o.history = 1000 -- Command history
vim.o.directory = vim.fn.expand("~/.config/nvim/swap//")
vim.o.updatetime = 250 -- time before swap file is written on the disk
vim.o.backupdir = vim.fn.expand("~/.config/nvim/backup//")

-- SEARCH
vim.o.ignorecase = true -- Case insensitive search
vim.o.smartcase = true -- Sensible to capital letters
vim.o.incsearch = true -- Show search results as you type
vim.o.hlsearch = false -- Don't highlight all search results


-- [ UI settings ]

vim.o.shortmess = "I" -- disable start message
vim.o.wrap = false -- by default disable wrap (can be individually enabled by language)
vim.o.linebreak = true -- when wrap enabled, wrap at the end of the words

-- theme
vim.o.termguicolors = true -- add more color
vim.g.gruvbox_italic = 1 -- italic for comments
vim.cmd [[colorscheme gruvbox]]

-- colors
vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]] -- transparent background
vim.cmd [[highlight SignColumn guibg=NONE]] -- Sign column has same color as number column
vim.cmd [[highlight CursorLineNr guifg=#fe8019 guibg=NONE]] -- current line in gruvbox light orange
vim.cmd [[highlight IncSearch guifg=#b8bb26]] -- search in green

vim.cmd [[highlight GitSignsAdd guibg=NONE guifg=#b4b926]] -- + in the margin for git
vim.cmd [[highlight GitSignsChange guibg=NONE guifg=#8cbd7b]]
vim.cmd [[highlight GitSignsDelete guibg=NONE guifg=#e44936]]

vim.cmd [[highlight IndentBlanklineChar guifg=#413b35]] -- Indent line : very dark comments

-- show line numbers and highlight cursor line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.wo.signcolumn = 'yes'

-- set invisible chars
vim.o.list = true
vim.opt.listchars = { extends = '→', precedes = '←', trail = '·' }
