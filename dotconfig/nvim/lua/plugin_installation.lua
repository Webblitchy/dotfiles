-------------------------------------------------------------------------------------------
-- Plugin Installation
-------------------------------------------------------------------------------------------

-- Install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- When adding new plugins : run ":PackerInstall"
require("packer").startup(function(use)
  -- Package manager
  use "wbthomason/packer.nvim"

  use { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      "j-hui/fidget.nvim",

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
    config = {
      require('mason').setup()
    }
  }

  use { -- Autocompletion
    "hrsh7th/nvim-cmp",
    requires = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  }

  use { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  }

  -- Git related plugins
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  use "lewis6991/gitsigns.nvim"

  -- Nice icons (useful for many plugins)
  use "nvim-tree/nvim-web-devicons"

  -- Fancier statusline
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true } -- to add icons
  }

  -- Bufferline
  use {
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    requires = "nvim-tree/nvim-web-devicons"
  }

  -- Theme
  use("ellisonleao/gruvbox.nvim")

  use "lukas-reineke/indent-blankline.nvim" -- Add indentation guides even on blank lines
  use {                                     -- "gc" to comment visual regions/lines
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }
  -- using packer.nvim
  use { -- Detect indentation for existing files
    "nmac427/guess-indent.nvim",
    config = function() require("guess-indent").setup {} end,
  }

  -- Fuzzy Finder (files, lsp, etc)
  use { "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 }

  -- Telescope acting like a finder
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" }
  }

  -- Highlight todo in the file
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  }
  use "lervag/vimtex" -- latex compilation

  -- Startup menu for nvim
  use {
    "startup-nvim/startup.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require "startup".setup {}
    end
  }

  -- Tree to find files
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
  }

  -- show the mappings
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 600
      require("which-key").setup {}
    end
  }

  -- Metals (used for scala lsp)
  use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

  -- Use formatter when not available in lsp
  use "jose-elias-alvarez/null-ls.nvim"
  use("jay-babu/mason-null-ls.nvim") -- use mason to install formatters

  -- Save with sudo
  use "lambdalisue/suda.vim"

  -- change and add surroundings (", ', (, [, html tags...)
  use "tpope/vim-surround"

  -- color hex codes
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require 'colorizer'.setup {
        '*', -- all
        -- '!vim' -- except
      }
    end
  }


  -- [[ Debugging ]]
  use 'mfussenegger/nvim-dap'
  use "jay-babu/mason-nvim-dap.nvim" -- autoinstall debug clients (not dap clients)
  -- UI
  use "theHamsta/nvim-dap-virtual-text"
  use "rcarriga/nvim-dap-ui"
  use "nvim-telescope/telescope-dap.nvim"
  -- language adapters
  use "mfussenegger/nvim-dap-python"


  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, "custom.plugins")
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require("packer").sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn"t
-- make sense to execute the rest of the init.lua.
--
-- You"ll need to restart nvim, and then it will work.
if is_bootstrap then
  print "=================================="
  print "    Plugins are being installed"
  print "    Wait until Packer completes,"
  print "       then restart nvim"
  print "=================================="
  return
end

-- Automatically source and re-compile packer whenever you save this file
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | PackerSync",
  group = vim.api.nvim_create_augroup("Packer", { clear = true }),
  pattern = "plugin_installation.lua"
})
