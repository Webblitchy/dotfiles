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
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation') -- Show Documentation for the current function / class (in hover view)
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
local lsp_servers = {
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


-- [[ MASON ]]
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(lsp_servers), -- install the defined servers
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = lsp_servers[server_name],
    }
  end,
}

-- [ NULL-LS ]
local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.black, -- python formatting
    -- diagnostics.flake8
    formatting.shfmt, -- bash formatting

  },
})

-- Auto Download Null-LS sources
require("mason-null-ls").setup({
  ensure_installed = nil,
  automatic_installation = true, -- auto install formatters defined in null-ls
  automatic_setup = false,
})


-- Auto format file when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    if vim.lsp.buf.server_ready() then
      vim.lsp.buf.format()
    end
  end,
})

-- Preview markdown in okular with :MD
vim.cmd [[command! -complete=shellcmd -nargs=1 -bang Silent execute ':silent !' . (<bang>0 ? 'nohup ' . <q-args> . '</dev/null >/dev/null 2>&1 &' : <q-args>) | execute ':redraw!']]
vim.cmd [[command! MD Silent! okular %:S]]


-- [ NVIM METALS ]
-- Configure nvim-metals (for scala lsp)
--
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
