-------------------------------------------------------------------------------------------
-- Require the different config files
-------------------------------------------------------------------------------------------
require("myFunctions")         -- utility functions and personnal ones

require("vim_config")          -- set basic vim settings

require("keymaps")             -- set standard keymaps (not related to plugins)

require("commands")            -- set commands to be run automatically or by user

require("plugin_installation") -- commands to install the plugins (with Packer)


-- Plugin config files
require("plugins.gruvbox")           -- set theme
require("plugins.lualine")           -- to change the status line
require("plugins.comment")           -- to toggle comments
require("plugins.indent-blankline")  -- to show indentation as line
require("plugins.gitsigns")          -- to show git line status in left bar
require("plugins.telescope")         -- fuzzy finder with a nice popup interface
require("plugins.nvim-web-devicons") -- to add nice icons for filetypes
require("plugins.vimtex")            -- to add latex compilation and live randering
require("plugins.startup")           -- to add a nice welcome screen
require("plugins.nvim-treesitter")   -- better highlighting and object selection
require("plugins.lsp")               -- handle language server protocols
require("plugins.nvim-cmp")          -- handle autocompletion
require("plugins.nvim-tree")         -- file tree
require("plugins.nvim-colorizer")
