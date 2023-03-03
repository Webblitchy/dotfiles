-- OPTION FOR STARTUP MENU ONLY

-- Hide border
vim.opt_local.signcolumn = "no"

-- Hide tildes at the end of file
vim.opt_local.fillchars = 'eob: '

-- Add horizonal line for cursor
vim.opt_local.cursorlineopt = "line"

-- Disable vim position info
vim.opt_local.ruler = false

-- Hide cursor
vim.cmd [[hi Cursor blend=100]]
vim.cmd [[set guicursor+=a:Cursor/lCursor]]

-- Hide numbers
vim.opt_local.number = false
vim.opt_local.relativenumber = false

-- Parameters are restored to default when lauching a new file
-- (in lua/startup_nvim.lua)
