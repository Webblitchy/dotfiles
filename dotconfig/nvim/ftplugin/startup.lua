vim.opt_local.signcolumn = "no"
vim.opt_local.cursorlineopt = "line"
-- Hide cursor
vim.cmd [[hi Cursor blend=100]]
vim.cmd [[set guicursor+=a:Cursor/lCursor]]
