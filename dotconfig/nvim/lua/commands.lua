-- [ AUTO CMD ]

-- always have a 1/4 of the screen of margin after / before the cursor
vim.api.nvim_create_autocmd({ "VimResized", "VimEnter", "WinEnter", "WinLeave" }, {
  callback = function()
    -- vim.api.nvim_command(":set scrolloff=" .. math.ceil(vim.api.nvim_get_option("lines") / 4))
    vim.wo.scrolloff = math.ceil(vim.api.nvim_win_get_height(0) / 4)
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

-- replace term in new tab default behavior
local hideBordersCommand = "set nonumber | set norelativenumber | set signcolumn=no"
local showBordersCommand = "set number | set relativenumber | set signcolumn=yes"

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local termBuf = vim.api.nvim_get_current_buf() -- save term buffer
    local termSize = math.ceil(vim.api.nvim_win_get_height(0) / 3)
    vim.api.nvim_command("b#") -- go to previous buffer
    vim.api.nvim_command("botright new") -- create a splitwindow
    vim.api.nvim_input('<C-w>j<CR>') -- go to new window
    vim.api.nvim_command("res " .. termSize) -- resize terminal
    vim.api.nvim_command("b " .. termBuf) -- reopen the term buffer
    vim.api.nvim_command("" .. hideBordersCommand)
    -- vim.opt_local.laststatus = 0 -- disable statusline (lualine in my case)
    vim.opt_local.showmode = false
    vim.opt_local.shortmess:append({ F = true })
    vim.api.nvim_input('a') -- interactive mode
  end
})

vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    -- vim.opt_local.laststatus = 2 -- reenable statusline
    -- vim.api.nvim_input("<C-Y>") -- scroll up (directly quit terminal without status)
  end
})


-- Add missing filetypes
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  callback = function()
    vim.opt_local.filetype = "sage"
  end,
  pattern = "*.sage"
})


-- Auto format file when saving file
-- vim.api.nvim_create_autocmd("QuitPre", {
--   callback = function()
--     IsQuitting = true
--   end
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    FormatOnSave()
  end
})

-- vim.cmd [[cabbrev wq lua FormatOnSave() vim.api.nvim_input("ZZ")]]
--

-- [ NEW USER COMMANDS ]

-- Handle side bar
BarHidden = false
function ToggleHide()
  if BarHidden then
    BarHidden = false
    vim.api.nvim_command(showBordersCommand .. " | IndentBlanklineEnable")
  else
    BarHidden = true
    vim.api.nvim_command(hideBordersCommand .. " | IndentBlanklineDisable")
  end
end

vim.api.nvim_create_user_command(
  'Bar', -- must start with uppercase
  "lua ToggleHide()",
  {}
)


-- Save with sudo (requires Suda plugin)
vim.api.nvim_create_user_command(
  "W",
  "SudaWrite",
  {}
)

-- Open with sudo (requires Suda plugin)
vim.api.nvim_create_user_command(
  "R",
  "SudaRead",
  {}
)


-- Preview markdown in okular with :MD
vim.cmd [[command! -complete=shellcmd -nargs=1 -bang Silent execute ':silent !' . (<bang>0 ? 'nohup ' . <q-args> . '</dev/null >/dev/null 2>&1 &' : <q-args>) | execute ':redraw!']]
vim.cmd [[command! MD w | Silent! okular %:S]]
