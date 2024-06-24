-------------------------------------------------------------------------------------------
-- Keymaps Settings
-------------------------------------------------------------------------------------------

--local popup = require("plenary.popup")
local map = vim.keymap.set -- local alias for conciseness

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ remaps ]]
-- Make ctrl-c work always as esc
map("", '<C-c>', '<Esc>', { remap = true }) -- recursive mapping

-- When going to start of line (^) : scroll screen to left
map("n", '^', '^ze', { remap = true }) -- recursive mapping

-- replace weird vim feature to "cut and paste" with "delete and paste"
map("v", "p", "\"_dP")

-- disable copy when using x
map({ "n", "v" }, "x", "\"_x")

-- ctrl backspace for removing a whole word
map({ "i", "c" }, "<C-H>", "<C-W>", { desc = "Remove precedent word" })
-- Works with wezterm and Konsole (use <C-BS> for kitty)

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- hide messages on Esc (and also ctrl-c)
--map("n", "<Esc>", "<Esc>:echo ''<CR>", { silent = true })


-- Disable space in normal mode (better for leader key)
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })


map("n", "<CR>", "") -- disable "return" in normal mode
map("n", "q:", ":")  -- replace q: by : to avoid errors

-- Tab auto indent correctly on empty line (insert <C-f>)
map("i", "<TAB>",
  function()
    -- smart indent
    if vim.api.nvim_get_current_line() == "" then
      vim.api.nvim_feedkeys("i" .. Keycode("<C-f>") .. " " .. Keycode("<BS>"), "n", false)
      vim.api.nvim_feedkeys("", "x", true) -- empty feed buffer

      -- Force insert a tab when ctrl-f didn't do anything
      if vim.api.nvim_get_current_line() == "" then
        vim.api.nvim_feedkeys(Keycode("<TAB>"), "n", false)
      end

      -- Pass in insert mode again
      vim.api.nvim_input("<ESC>A")
    else
      -- normal TAB
      vim.api.nvim_feedkeys(Keycode("<TAB>"), "n", false)
    end
  end
)

-- Add a message when restartingSearch
map("n", "n",
  function()
    -- close popup (for restartingSearch popup)
    for _, winNb in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winNb).relative ~= "" then -- is popup
        vim.api.nvim_win_close(winNb, true)                     -- close
      end
    end

    local searchWord = vim.fn.histget("search", -1)
    vim.api.nvim_input("/" .. searchWord .. "<CR>")

    if vim.b.searchStartPos == 0 then -- if was a new search
      vim.b.searchStartPos = vim.fn.searchcount().current
    elseif vim.b.searchStartPos == GetNextSearchCount() then
      vim.b.searchStartPos = 0 -- restart search
      ShowPopup("󰑐 Restarting search")
      return
    end
  end
)


-- Easier switch between buffers
--
-- Standard buffers
-- map("n", "<C-B>", ":bn<CR>", { silent = true })

-- use cokeline (avoid hidden buffers)
map("n", "<C-B>", '<Plug>(cokeline-focus-next)', { silent = true, desc = "Goto next buffer" })
map("n", "<C-Right>", '<Plug>(cokeline-focus-next)', { silent = true, desc = "Goto next buffer" })
map("n", "<Tab>", '<Plug>(cokeline-focus-next)', { silent = true, desc = "Goto next buffer" })
map("n", "<C-Left>", '<Plug>(cokeline-focus-prev)', { silent = true, desc = "Goto precedent buffer" })
map("n", "<C-Q>", ":bd<CR>", { silent = true, desc = "Close buffer" })

-- Make more use of H and L
map("n", "<S-H>", "{")
map("n", "<S-L>", "}")



-- Open terminal
map("n", "<leader>t", ":terminal<CR>", { silent = true, desc = "Open a terminal sub window" })

-- [[ USER COMMANDS ]]
-- Execute file on leader x
map("n", "<leader>x",
  function()
    vim.api.nvim_command("write")
    AutoCompile()
  end,
  { desc = "Execute code" }
)

-- marks
map("n", "mm", ToggleGlobalMark)
map("n", "md", "<Plug>(Marks-deleteline)")

-- Diagnostic keymaps (warnings and errors)
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = "Diagnostic popup" })
map('n', '<leader>q', vim.diagnostic.setqflist, { desc = "Diagnostic sub window" })

-- Terminal remaps
map("t", "<C-W>", "<C-\\><C-N><C-W>") -- move to other window as usual

-- Inlay hints
map(
  'n',
  '<leader>h',
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
  { desc = "Toggle Inlay Hints" }
)


-- [[ PLUGINS ]]

-- ctrl + 7 for commenting code
map('n', '<C-7>', 'gcc', { desc = "Toggle comment", remap = true })
map('v', '<C-7>', 'gc', { desc = "Toggle comment", remap = true })
-- Works with kitty and wezterm (use  for Konsole)

-- Git
map("n", "<leader>g", ":Git<CR>")         -- git status
map("n", "<leader>d", ":Gvdiffsplit<CR>") -- git diff view


-- Show NvimTree
map("n", "<C-T>", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle NvimTree" })

-- Dap
map(
  "n",
  "<leader>b",
  ":lua require('dap').toggle_breakpoint()<CR>",
  { silent = true, desc = "DAP: Toggle breakpoint" }
)
map(
  "n",
  "<leader>B",
  ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { silent = true, desc = "DAP: Toggle conditinal breakpoint" }
)
map(
  "n",
  "<F1>",
  ":lua require('dap').continue()<CR>",
  { silent = true, desc = "DAP: Continue" }
)
map(
  "n",
  "<F2>",
  ":lua require('dap').step_over()<CR>",
  { silent = true, desc = "DAP: Step over" }
)
map(
  "n",
  "<F3>",
  ":lua require('dap').step_into()<CR>",
  { silent = true, desc = "DAP: Step into" }
)
map(
  "n",
  "<F4>",
  ":lua require('dap').terminate()<CR>",
  { silent = true, desc = "DAP: Terminate" }
)
