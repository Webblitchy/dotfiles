-------------------------------------------------------------------------------------------
-- Keymaps Settings
-------------------------------------------------------------------------------------------

local map = vim.keymap.set -- local alias for conciseness

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make ctrl-c work always as esc
map({ 'n', 'i', 'v' }, '<C-c>', '<Esc>')

-- ctrl backspace for removing a whole word
map("i", "", "<C-W>")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
map("n", "<leader>t", ":terminal<CR>", { silent = true })

-- Hide
map("n", "<leader>b", ":Bar<CR>", { silent = true, nowait = true })

-- Execute file on leader x
map("n", "<leader>x", function()
  vim.api.nvim_command("write")
  local fileName = vim.api.nvim_buf_get_name(0)
  local fileType = vim.bo.filetype
  local workspaceFolder = vim.lsp.buf.list_workspace_folders()[1]

  local function executeFile(command)
    vim.api.nvim_command("term cd " .. workspaceFolder .. " && " .. command)
  end

  if fileType == "python" then
    executeFile("python " .. fileName)
  elseif fileType == "rust" then
    executeFile("cargo run")
  elseif fileType == "sh" then
    executeFile("bash < " .. fileName)
  end
end)

-- Diagnostic keymaps (warnings and errors)
-- TODO: useful ?
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '<leader>q', vim.diagnostic.setloclist)

-- Terminal remaps
map("t", "<C-W>", "<C-\\><C-N><C-W>") -- move to other window as usual
