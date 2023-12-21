-------------------------------------------------------------------------------------------
-- Plugin Installation
-------------------------------------------------------------------------------------------

-- Install lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- When adding new plugins : Lazy
require("lazy").setup({

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua neovim configuration
      "folke/neodev.nvim",
    },
  },

  -- Use formatter when not available in lsp
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")
    end,
  },
  "WhoIsSethDaniel/mason-tool-installer.nvim", -- use mason to install formatters

  {
    -- Autocompletion (with menu)
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim", -- add fancy icons
      "f3fora/cmp-spell",
      "hrsh7th/cmp-path",
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },


  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",

  -- Nice icons (useful for many plugins)
  "nvim-tree/nvim-web-devicons",

  -- Fancier statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      -- "arkav/lualine-lsp-progress",  -- LSP status in lualine
      'linrongbin16/lsp-progress.nvim',
    },
    lazy = false
  },

  -- Bufferline
  {
    "willothy/nvim-cokeline",
    lazy = false
  },

  -- Scroll bar
  -- { "dstein64/nvim-scrollview", },
  { "petertriho/nvim-scrollbar", },

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
  },

  -- Add indentation guides even on blank lines
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },


  -- Detect indentation for existing files
  {
    "nmac427/guess-indent.nvim",
    config = function() require("guess-indent").setup {} end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
  },

  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable "make" == 1
  },

  -- Telescope acting like a finder
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim"
    }
  },

  -- Highlight todo in the file
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
  },

  {
    "lervag/vimtex", -- latex compilation
    ft = "tex"
  },

  -- Startup menu for nvim
  {
    'goolord/alpha-nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end,
    lazy = true,
  },

  -- Tree to find files
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    lazy = true,
  },

  -- show the mappings
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 600
    end,
    opts = {},
    event = "VeryLazy"
  },


  -- Save with sudo
  "lambdalisue/suda.vim",

  -- change and add surroundings (", ', (, [, html tags...)
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  -- color hex codes
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup({
          '*', -- all
          -- '!vim' -- except
        },
        {
          RGB = false,
          names = false,
          RRGGBBAA = true,
        })
    end
  },

  -- show marks in margin
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        force_write_shada = true, -- otherwise marks are not deleted
      })
    end
  },

  -- [[ Debugging ]]
  'mfussenegger/nvim-dap',
  "jay-babu/mason-nvim-dap.nvim", -- autoinstall debug clients (not dap clients)

  -- UI
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",
  "nvim-telescope/telescope-dap.nvim",

  -- language adapters
  {
    "mfussenegger/nvim-dap-python",
    ft = "python"
  }

}, {
  ui = {
    border = "rounded",
  },
})
