-------------------------------------------------------------------------------------------
-- [[ Vim manual settings ]] --

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
vim.o.termguicolors = true
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


-- [ AUTO CMD ]

-- always have a 1/3 of the screen of margin after / before the cursor
vim.api.nvim_create_autocmd({ "VimResized", "VimEnter", "WinEnter", "WinLeave" }, {
  callback = function()
    vim.api.nvim_command(":set scrolloff=" .. math.ceil(vim.api.nvim_get_option("lines") / 3))
  end
})

-- Restore cursor position when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    local currLine = vim.fn.line("'\"")
    local lastLine = vim.fn.line("$")
    if (currLine > 1 and currLine <= lastLine) then
      vim.api.nvim_command("normal! g'\"")
    end
  end
})


-----------------------------------------------------------------------------------------------
-- [[ Basic Keymaps ]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make ctrl-c work always as esc
vim.keymap.set({ 'n', 'i', 'v' }, '<C-c>', '<Esc>')

-- ctrl backspace for removing a whole word
vim.keymap.set('i', '', '<C-W>')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

--------------------------------------------------------------------------------------------
-- [[ PLUGINS INSTALLATION ]]
-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- When adding new plugins : run ":PackerInstall"
require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Nice icons (useful for many plugins)
  use 'nvim-tree/nvim-web-devicons'

  -- Fancier statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true } -- to add icons
  }

  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Telescope acting like a finder
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" }
  }


  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  use 'lervag/vimtex' -- latex compilation

  -- Startup menu for nvim
  use {
    "startup-nvim/startup.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require "startup".setup()
    end
  }

  -- Metals (used for scala lsp)
  use({ 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } })

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

--------------------------------------------------------------------------------------------
-- [[ PLUGINS CONFIGURATION ]] --

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_c = {
      {
        'filename',
        color = { fg = '#fabd2f' },
        path = 3 -- abs path
      },
    },
    lualine_b = {
      'branch', 'diff', 'diagnostics',
      {
        function() -- print the todo count (in comments)
          local comment = string.sub(vim.o.commentstring, 0, -4) -- get the comment pattern : "# %s" -> "#"
          local todos = vim.fn.searchcount({ pattern = comment .. ".*TODO:", recompute = 1 }).total
          if todos > 0 then
            return " " .. todos
          end
          return ""
        end,
        color = { fg = "#add8e6" }
      }
    },
    lualine_x = {
      {
        'fileformat',
        symbols = {
          unix = " LF", -- e712
          dos = " CRLF", -- e70f
          mac = " CR", -- e711
        }
      },
      function() -- wrapping
        -- Wrapping 󰯟 󰖶 󰴏 󰴐 󱞱 󱞲 →   󰞘 󰜴
        local wrapMode = ""
        if (vim.o.wrap == true) then
          wrapMode = wrapMode .. "󱞲"
        else
          wrapMode = wrapMode .. "󰞘"
        end
        return wrapMode
      end,
      function() -- tab size
        return " " .. vim.o.shiftwidth
      end,
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
}

-- Enable Comment.nvim
require('Comment').setup()
vim.api.nvim_set_keymap('n', '', 'gcc', { silent = true }) -- ctrl + 7 for line comment
vim.api.nvim_set_keymap('v', '', 'gc', { silent = true })


-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊', -- ┆ ⁞ ┊ ⸽ |
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '' }, -- +  
    change = { text = '󰥛' }, -- ~ 󱑺 󰣁 󰓦 󰜥 󱑼 
    delete = { text = '⎽' }, -- _ 𛲖 ＿ ₋ ⎽
    topdelete = { text = '‾' }, -- ⁻ ⎺
    changedelete = { text = '󰥛' },
  },
}


-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    layout_config = { preview_width = 0.6 } -- width as a percentage
  },
}
-- To setup file_browser after telescope is configured
require("telescope").load_extension "file_browser"
vim.api.nvim_set_keymap(
  "n",
  "<leader>bf",
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
  { noremap = true }
)

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


-- [[ Configure nvim-web-devicons ]]
require 'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  },
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true,
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true,
  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore"
    }
  },
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log"
    }
  },
}
-- [[ Configure VimTex ]] (for Latex)
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-pdf',
    '-shell-escape', -- necessary for minted (but can be dangerous)
    '-verbose',
    '-halt-on-error',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
  },
}
-- vim.api.nvim_create_autocmd({require("vimtex-events").VimtexEventQuit},{
--
-- })
-- TODO: Not working yet
-- fdsjkl vim.cmd [[autocmd! User VimtexEventQuit call vimtex#latexmk#clean(0)]]

-- Configure greathing menu on startup
require("startup").setup(require("startup_nvim")) -- use the file startup_nvim.lua

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- (used for better selection with c-space)
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'typescript', 'help', 'vim', 'scala' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.api.nvim_create_autocmd({ "BufWinEnter" }, { -- to unfold all at the begining
  command = "normal zR"
})

-- Diagnostic keymaps (warnings and errors)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame') -- refactor as in IntelliJ
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction') -- generate actions

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {}, -- C/C++
  pyright = {}, -- Python
  rust_analyzer = {}, -- Rust
  jdtls = {}, -- Java
  tsserver = {}, -- Javascript / TS
  marksman = {}, -- markdown
  lua_ls = {}, -- Lua
  bashls = {}, -- Bash
  html = {}, -- HTML
  jsonls = {}, -- json
  yamlls = {}, -- YAML
  lemminx = {}, -- XML
  ltex = {}, -- Latex
  --metals = {}, -- Scala (install metals with `cs install metals`)
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers), -- install the defined servers
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Auto format file when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.lsp.buf.server_ready() then
      vim.lsp.buf.format()
    end
  end,
})
-- Configure nvim-metals (for scala lsp)
-- local metals_config = require("metals").bare_config()
-- metals_config.settings = {
--   showImplicitArguments = true,
--   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
-- }
-- metals_config.init_options.statusBarProvider = "on"
--
-- -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
-- metals_config = require'metals'.bare_config()
-- metals_config.settings = {
--   showImplicitArguments = true,
--   excludedPackages = {
--     "akka.actor.typed.javadsl",
--     "com.github.swagger.akka.javadsl"
--   }
-- }
--
-- metals_config.on_attach = function()
--   require'completion'.on_attach();
-- end
--
-- metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = {
--       prefix = '',
--     }
--   }
-- )


-- vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach({
-- require'completion'.on_attach()
-- })]])



vim.opt_global.shortmess:remove("F") -- otherwise conflicts with metals
local metals_config = require 'metals'.bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  },
}

metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities

-- metals_config.on_attach = function()
--   require'completion'.on_attach();
-- end
local lsp_metals = vim.api.nvim_create_augroup("lsp", { clear = true })
metals_config.on_attach = function(client, bufnr)
  on_attach(client, bufnr)


  -- A lot of the servers I use won't support document_highlight or codelens,
  -- so we juse use them in Metals
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = vim.lsp.buf.document_highlight,
    buffer = bufnr,
    group = lsp_metals,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = vim.lsp.buf.clear_references,
    buffer = bufnr,
    group = lsp_metals,
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = vim.lsp.codelens.refresh,
    buffer = bufnr,
    group = lsp_metals,
  })
end

metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = '',
  }
}
)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { 'scala', 'sbt', 'worksheet.sc' },
  callback = function()
    require("metals").initialize_or_attach({ metals_config })
  end
})

---------------------------------

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
