-- Catppuccin

local catppuccin_palette = require("catppuccin.palettes.mocha")

require("catppuccin").setup({
  flavour = "mocha",          -- latte, frappe, macchiato, mocha
  transparent_background = false,
  show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false, -- Force no italic
  no_bold = false,   -- Force no bold
  styles = {
    comments = { "italic" },
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = {},
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,

    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- GRUVBOX
-- local gruvbox_palette = require("gruvbox.palette").colors
-- require("gruvbox").setup({
--   undercurl = true,
--   underline = true,
--   bold = true,
--   italic = {
--     comments = true,
--     strings = false,
--     operators = false,
--     folds = true
--   },
--   strikethrough = true,
--   invert_selection = true,
--   invert_signs = false,
--   invert_tabline = false,
--   invert_intend_guides = false,
--   inverse = true, -- invert background for search, diffs, statuslines and errors
--   contrast = "",  -- can be "hard", "soft" or empty string
--   palette_overrides = {},
--   overrides = {
--     CursorLineNr = { fg = gruvbox_palette.bright_orange, bg = "NONE" }, -- current line
--     IncSearch = { fg = gruvbox_palette.bright_green },                  -- search selection
--   },
--   dim_inactive = false,
--   transparent_mode = true, -- disable background color for transparent terminal
-- })
--

--]]

-- enable theme

-- vim.cmd("colorscheme gruvbox")
vim.cmd("colorscheme catppuccin")

-- color variables
-- GRUVBOX
-- local green = gruvbox_palette.bright_green    -- #b8bb26
-- local blue = gruvbox_palette.neutral_aqua     -- #689d6a
-- local lightBlue = gruvbox_palette.bright_aqua -- #8ec07c
-- local red = gruvbox_palette.bright_red        -- #fb4934
-- local orange = gruvbox_palette.faded_yellow   -- #b57614
-- local yellow = gruvbox_palette.bright_yellow  -- #fabd2f
-- local black = gruvbox_palette.dark0           -- #282828
-- local darkGray = gruvbox_palette.dark1        -- #3c3836
-- local gray = gruvbox_palette.dark3            -- #665c54
-- local darkWhite = gruvbox_palette.light4      -- #a89984
-- local white = gruvbox_palette.light1          -- #ebdbb2


-- catppuccin
local green      = catppuccin_palette.green    -- #A6E3A1
local lightGreen = catppuccin_palette.teal     -- #94E2D5
local blue       = catppuccin_palette.sapphire -- #74C7EC
local lightBlue  = catppuccin_palette.sky      -- #89DCEB
local red        = catppuccin_palette.red      -- #F38BA8
local pink       = catppuccin_palette.pink     -- #F5C2E7
local purple     = catppuccin_palette.mauve    -- #CBA6F7
local orange     = catppuccin_palette.peach    -- #FAB387
local yellow     = catppuccin_palette.yellow   -- #F9E2AF
local black      = catppuccin_palette.crust    -- #11111B
local darkGray   = catppuccin_palette.mantle   -- #181825
local background = catppuccin_palette.base     -- #1E1E2E
local gray       = catppuccin_palette.surface1 -- #45475A
local lightGray1 = catppuccin_palette.overlay0 -- #6C7086
local lightGray2 = catppuccin_palette.overlay1 -- #7F849C
local lightGray3 = catppuccin_palette.overlay2 -- #9399B2
local lightGray4 = catppuccin_palette.subtext0 -- #A6ADC8
local darkWhite  = catppuccin_palette.subtext1 -- #BAC2DE
local white      = catppuccin_palette.text     -- #CDD6F4


-- git sign colors
-- vim.cmd("highlight GitSignsAdd guibg=NONE guifg=" .. green)
-- vim.cmd("highlight GitSignsChange guibg=NONE guifg=" .. lightBlue)
-- vim.cmd("highlight GitSignsChangeDelete guibg=NONE guifg=" .. lightBlue)
-- vim.cmd("highlight GitSignsDelete guibg=NONE guifg=" .. red)
-- vim.cmd("highlight GitSignsTopDelete guibg=NONE guifg=" .. red)
-- vim.cmd("highlight GitSignsUntracked guibg=NONE guifg=" .. orange)

-- lsp colors
vim.cmd("highlight DiagnosticVirtualTextError guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextWarn guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextInfo guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextHint guibg=NONE")

-- Indent signs
vim.cmd("highlight IndentBlanklineChar guifg=" .. darkGray)    -- Indent line : very dark comments
vim.cmd("highlight IndentBlanklineContextChar guifg=" .. gray) -- Current indent line

-- Dap
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = red, bg = '' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = blue, bg = '' })

-- DapUI
vim.cmd("highlight DapUIBreakpointsDisabledLine guifg=" .. darkGray)
vim.cmd("highlight DapUIBreakpointsCurrentLine guifg=" .. lightGreen)
vim.cmd("highlight DapUICurrentFrameName guifg=" .. lightGreen)
vim.cmd("highlight DapUIBreakpointsPath guifg=" .. lightBlue)
vim.cmd("highlight DapUIBreakpointsLine guifg=" .. lightBlue)
vim.cmd("highlight DapUIBreakpointsInfo guifg=" .. lightGreen)
vim.cmd("highlight DapUIUnavailableNC guifg=" .. darkGray)
vim.cmd("highlight DapUIStoppedThread guifg=" .. lightBlue)
vim.cmd("highlight DapUIModifiedValue guifg=" .. lightBlue)
vim.cmd("highlight DapUIWatchesValue guifg=" .. lightGreen)
vim.cmd("highlight DapUIWatchesError guifg=" .. red)
vim.cmd("highlight DapUIWatchesEmpty guifg=" .. red)
vim.cmd("highlight DapUIUnavailable guifg=" .. darkGray)
vim.cmd("highlight DapUIPlayPauseNC guifg=" .. lightGreen)
vim.cmd("highlight DapUIFloatNormal guifg=" .. white)
vim.cmd("highlight DapUIFloatBorder guifg=" .. lightBlue)
vim.cmd("highlight DapUIEndofBuffer guifg=" .. white)
vim.cmd("highlight DapUIStepOverNC guifg=" .. lightBlue)
vim.cmd("highlight DapUIStepIntoNC guifg=" .. lightBlue)
vim.cmd("highlight DapUIStepBackNC guifg=" .. lightBlue)
vim.cmd("highlight DapUILineNumber guifg=" .. lightBlue)
vim.cmd("highlight DapUIDecoration guifg=" .. lightBlue)
vim.cmd("highlight DapUIWinSelect guifg=" .. lightBlue)
vim.cmd("highlight DapUIStepOutNC guifg=" .. lightBlue)
vim.cmd("highlight DapUIRestartNC guifg=" .. lightGreen)
vim.cmd("highlight DapUIPlayPause guifg=" .. lightGreen)
vim.cmd("highlight DapUIFrameName guifg=" .. white)
vim.cmd("highlight DapUIVariable guifg=" .. white)
vim.cmd("highlight DapUIStepOver guifg=" .. lightBlue)
vim.cmd("highlight DapUIStepInto guifg=" .. lightBlue)
vim.cmd("highlight DapUIStepBack guifg=" .. lightBlue)
vim.cmd("highlight DapUINormalNC guifg=" .. white)
vim.cmd("highlight DapUIStepOut guifg=" .. lightBlue)
vim.cmd("highlight DapUIRestart guifg=" .. lightGreen)
vim.cmd("highlight DapUIThread guifg=" .. lightGreen)
vim.cmd("highlight DapUIStopNC guifg=" .. red)
vim.cmd("highlight DapUISource guifg=" .. purple)
vim.cmd("highlight DapUINormal guifg=" .. white)
vim.cmd("highlight DapUIValue guifg=" .. white)
vim.cmd("highlight DapUIScope guifg=" .. lightBlue)
vim.cmd("highlight DapUIType guifg=" .. purple)
vim.cmd("highlight DapUIStop guifg=" .. red)

-- NVIM Tree
-- vim.cmd("highlight NvimTreeCursorLine guifg=" .. red)


-- Transparency handled by theme
-- vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]
-- transparent background
-- vim.cmd [[highlight SignColumn guibg=NONE]] -- Sign column has same color as number column
