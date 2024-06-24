-- Auto install formatters
require("mason-tool-installer").setup({
  ensure_installed = {
    "prettier", -- prettier formatter
    "black",    -- python formatter
    "shfmt",    -- bash formatter
    "djlint",   -- django formatter
  },
})

-- Configure formatters
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
    python = { "black" },
    bash = { "shfmt" },
    htmldjango = { "djlint" },
  },
})
