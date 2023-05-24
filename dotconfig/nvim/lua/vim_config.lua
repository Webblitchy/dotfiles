-------------------------------------------------------------------------------------------
-- Basic vim settings
-------------------------------------------------------------------------------------------

vim.o.mouse = ""                              -- disable mouse
vim.opt.confirm = true                        -- confirm to save changes before exiting modified buffer
vim.opt.showmode = false                      -- hide mode (shown with lualine)
vim.opt.showcmd = false                       -- hide keypressed entered
vim.o.completeopt = 'menuone,noselect'        -- Set completeopt to have a better completion experience
vim.opt.spelllang = { "en", "fr" }            -- dictionnary used for spell check
vim.opt.spellfile = vim.fn.stdpath("config") ..
    "/spell/custom.utf-8.add"                 -- custom dictionnary used (for all languages) : in .nvim/spell/
vim.opt.clipboard = "unnamedplus"             -- use OS clipboard (require xclip on X11)
vim.opt.nrformats = { "bin", "hex", "alpha" } -- increment with ^a also for letters

-- Indentation settings
vim.o.copyindent = true              -- copy the previous indentation on autoindenting
vim.o.breakindent = true             -- Enable break indent
vim.o.shiftround = true              -- use multiple of shiftwidth when indenting with '<' and '>'
vim.o.smartindent = true
vim.o.tabstop = 3                    -- visual size of tabs (when no expandtab)
vim.o.shiftwidth = 4                 -- default number of spaces to use for autoindenting
vim.o.softtabstop = vim.o.shiftwidth -- when hitting <BS>, pretend like a tab is removed, even if spaces
vim.o.expandtab = true               -- expand tabs to spaces
--> guess-indent can change these settings when reading existing file


-- History
vim.o.undofile = true
vim.o.undoreload = 10000
vim.o.undodir = vim.fn.expand("~/.config/nvim/undo//") -- to have all undos in the same dir (expand for tilde)
vim.o.directory = vim.fn.expand("~/.config/nvim/swap//")
vim.o.updatetime = 250                                 -- time before swap file is written on the disk
vim.o.backupdir = vim.fn.expand("~/.config/nvim/backup//")

-- SEARCH
vim.o.ignorecase = true -- Case insensitive search
vim.o.smartcase = true  -- Sensible to capital letters
vim.o.hlsearch = false  -- Don't highlight all search results

-- Language settings
vim.g.c_syntax_for_h = true -- set filetype to c for h files


-- [ UI settings ]

vim.o.shortmess = "I"  -- disable start message
vim.o.wrap = false     -- by default disable wrap (can be individually enabled by language)
vim.o.linebreak = true -- when wrap enabled, wrap at the end of the words


-- show line numbers and highlight cursor line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.wo.signcolumn = 'yes'

-- set invisible chars
vim.o.list = true
vim.opt.listchars = {
    extends = '→',
    precedes = '←',
    trail = '·',
    tab = "  ", -- Needs between 2-3 chars : ⊦ ┄╞ ▸ ⊳
}
