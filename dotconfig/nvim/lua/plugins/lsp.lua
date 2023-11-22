-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc) -- just to simplify mapping
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>r", vim.lsp.buf.rename, "[R]ename")           -- refactor as in IntelliJ
  nmap("<leader>a", vim.lsp.buf.code_action, "code [A]ction") -- Apply fix

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")

  -- useless
  -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- Show Documentation for the current function / class (in hover view)
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
local lsp_servers = {
  clangd = {},        -- C/C++
  pyright = {},       -- Python
  rust_analyzer = {}, -- Rust
  jdtls = {},         -- Java
  tsserver = {},      -- Javascript / TS
  marksman = {},      -- markdown
  lua_ls = {
    Lua = {
      workspace = {
        -- Make the server aware of Neovim runtime files
        checkThirdParty = false, -- to stop asking for third party in nvim
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    }
  },            -- Lua
  bashls = {},  -- Bash
  html = {},    -- HTML
  jsonls = {},  -- json
  yamlls = {},  -- YAML
  lemminx = {}, -- XML
  ltex = {
    ltex = {
      language = { "fr", "en" },
      disabledRules = {
        ["en"] = { "PROFANITY", "DATE" },
        ["fr"] = { "PROFANITY", "DATE" },
      },
      dictionary = {
        ["en"] = CustomDictionnary(),
        ["fr"] = CustomDictionnary(),
      },
    },
  },
  cssls = {}, -- CSS
}

-- Setup neovim lua configuration
require("neodev").setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)


-- [[ MASON ]]
require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
  },
})
-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(lsp_servers), -- install the defined servers
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = lsp_servers[server_name], -- defined in the curly brackets
    }
  end,
}

-- [[ Specific lsp settings ]]

-- to disable small functions as one-liners (with LLVM style)
table.insert(require("lspconfig")["clangd"].cmd, "--fallback-style=Chromium")

-- Change border of documentation hover window (Shift-K), See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
-- Same for signatureHelp (Ctrl-k)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

-- Edit lsp diagnostics signs (in margin)
local signs = require("../icons").lspSigns
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Edit inline (+ popup) diagnostic preferences
vim.diagnostic.config({
  virtual_text = {
    prefix = "", -- Could be 󰔰 󰜋 󰹞 󰏃 󰊍 󰭹  ■ ▎ (one char width is better)
  },
  severity_sort = true,
  -- update_in_insert = true, -- overwhelming
  float = {
    source = "if_many", -- or "always"
    border = "rounded",
  },
})
