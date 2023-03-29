local palette = require("gruvbox.palette").colors

require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    comments = true,
    strings = false,
    operators = false,
    folds = true
  },
  strikethrough = true,
  invert_selection = true,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
    CursorLineNr = { fg = palette.bright_orange, bg = "NONE" }, -- current line
    IncSearch = { fg = palette.bright_green }, -- search selection
    -- String = { italic = false }
  },
  dim_inactive = false,
  transparent_mode = true,
})

-- enable theme
vim.cmd("colorscheme gruvbox")

-- color settings
vim.o.termguicolors = true -- add more color


-- git sign colors (not available in gruv config
vim.cmd("highlight GitSignsAdd guibg=NONE guifg=" .. palette.bright_green) -- + in the margin for git
vim.cmd("highlight GitSignsChange guibg=NONE guifg=" .. palette.bright_aqua)
vim.cmd("highlight GitSignsChangeDelete guibg=NONE guifg=" .. palette.bright_aqua)
vim.cmd("highlight GitSignsDelete guibg=NONE guifg=" .. palette.neutral_red)
vim.cmd("highlight GitSignsTopDelete guibg=NONE guifg=" .. palette.neutral_red)

-- Indent signs
vim.cmd("highlight IndentBlanklineChar guifg=" .. palette.dark1) -- Indent line : very dark comments


-- NVIM Tree
-- vim.cmd("highlight NvimTreeCursorLine guifg=" .. palette.bright_red)


-- Transparency handled by gruvbox
-- vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]] -- transparent background
-- vim.cmd [[highlight SignColumn guibg=NONE]] -- Sign column has same color as number column
