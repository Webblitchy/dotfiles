vim.o.wrap = true
-- spelling check is done by ltex lsp
require('lspconfig').ltex.setup({
  settings = {
    ltex = {
      language = { "fr", "en" },
    }
  },
})

vim.g.vimtex_quickfix_open_on_warning = 0
