-------------------------------------------------------------------------------------------
-- Keymaps Settings
-------------------------------------------------------------------------------------------

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make ctrl-c work always as esc
vim.keymap.set({ 'n', 'i', 'v' }, '<C-c>', '<Esc>')

-- ctrl backspace for removing a whole word
vim.keymap.set("i", "", "<C-W>")

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

-- Open terminal
vim.keymap.set("n", "<leader>t", ":terminal<CR>")

-- Execute file on leader x
vim.keymap.set("n", "<leader>x", function()
  vim.api.nvim_command("write")
  local fileName = vim.api.nvim_buf_get_name(0)
  local fileType = vim.bo.filetype
  local workspaceFolder = vim.lsp.buf.list_workspace_folders()[1]

  local function executeFile(command)
    vim.api.nvim_command("term cd " .. workspaceFolder .. " && " .. command)
  end

  if fileType == "python" then
    -- vim.api.nvim_command("term python " .. fileName)
    executeFile("python " .. fileName)
  elseif fileType == "rust" then
    -- vim.api.nvim_command("term cd " .. workspaceFolder .. " && cargo run " .. fileName)
    executeFile("cargo run")
  end
end)

-- Diagnostic keymaps (warnings and errors)
-- TODO: useful ?
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
