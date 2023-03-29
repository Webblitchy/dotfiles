-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "name",
  hijack_cursor = true, -- keep cursor on begin
  git = {
    enable = false, -- show selected files in commits
  },
  view = {
    width = 30,
    side = "left",
    mappings = {
      list = {
        { key = "<C-T>", action = "close" }, -- to close the same way I open it
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  diagnostics = {
    enable = true,
  },
  filters = {
    dotfiles = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  modified = {
    enable = true
  }
})

-- to toggle nvim tree
vim.keymap.set("n", "<C-T>", ":NvimTreeToggle<CR>", { silent = true })
