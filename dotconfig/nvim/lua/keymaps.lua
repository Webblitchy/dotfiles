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
if vim.env.TERM == "xterm-256color" then
  map({ "i", "c" }, "", "<C-W>")
elseif vim.env.TERM == "xterm-kitty" then
  map({ "i", "c" }, "<C-BS>", "<C-W>")
end

map("n", "<CR>", "ciw") -- enter to change word in normal mode


-- Easier switch between buffers
--
-- Standard buffers
-- map("n", "<C-B>", ":bn<CR>", { silent = true })

-- use cokeline (avoid hidden buffers)
map("n", "<C-B>", '<Plug>(cokeline-focus-next)', { silent = true })

map("n", "<C-Q>", ":bd<CR>", { silent = true })

-- Make more use of H and L
map("n", "<S-H>", "{")
map("n", "<S-L>", "}")




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
map("n", "<leader>t", ":terminal<CR>", { silent = true, desc = "Open a terminal sub window" })

-- Execute file on leader x
map("n", "<leader>x",
  function()
    vim.api.nvim_command("write")
    AutoCompile()
  end,
  { desc = "Execute code" }
)

-- Diagnostic keymaps (warnings and errors)
-- TODO: useful ?
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Diagnostic popup" })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostic sub window" })

-- Terminal remaps
map("t", "<C-W>", "<C-\\><C-N><C-W>") -- move to other window as usual


-- PLUGINS

-- ctrl + 7 for commenting code
if vim.env.TERM == "xterm-256color" then
  vim.api.nvim_set_keymap('n', '', 'gcc', { silent = true })
  vim.api.nvim_set_keymap('v', '', 'gc', { silent = true })
elseif vim.env.TERM == "xterm-kitty" then
  vim.api.nvim_set_keymap('n', '<C-7>', 'gcc', { silent = true })
  vim.api.nvim_set_keymap('v', '<C-7>', 'gc', { silent = true })
end

-- Git
map("n", "<leader>g", ":Git<CR>")         -- git status
map("n", "<leader>d", ":Gvdiffsplit<CR>") -- git diff view


-- NvimTree
map("n", "<C-T>", ":NvimTreeToggle<CR>", { silent = false })

-- Dap
map("n", "<leader>b", ":lua require('dap').toggle_breakpoint()<CR>", { silent = true })
map("n", "<leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
map("n", "<F1>", ":lua require('dap').continue()<CR>", { silent = true })
map("n", "<F2>", ":lua require('dap').step_over()<CR>", { silent = true })
map("n", "<F3>", ":lua require('dap').step_into()<CR>", { silent = true })
