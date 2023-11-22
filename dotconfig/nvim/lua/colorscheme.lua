-- Catppuccin

local catppuccin_palette = require("catppuccin.palettes.mocha")

require("catppuccin").setup({
  flavour = "mocha",          -- latte, frappe, macchiato, mocha
  transparent_background = true,
  show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  term_colors = false,
  dim_inactive = {
    enabled = false,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false, -- Force no italic
  no_bold = false,   -- Force no bold
  no_underline = false,
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
    alpha = true,
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    mason = true,
    which_key = true,
    native_lsp = {
      enabled = true,
      underlines = {
        errors = { "undercurl" },
        warnings = { "undercurl" },
        hints = {},
        information = {},
      },
    },
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- enable theme
vim.cmd.colorscheme("catppuccin")


-- catppuccin mocha colors
Colors = {
  green       = catppuccin_palette.green,     -- #A6E3A1
  lightGreen  = catppuccin_palette.teal,      -- #94E2D5
  blue        = catppuccin_palette.sapphire,  -- #74C7EC
  lightBlue   = catppuccin_palette.sky,       -- #89DCEB
  red         = catppuccin_palette.red,       -- #F38BA8
  pink        = catppuccin_palette.pink,      -- #F5C2E7
  purple      = catppuccin_palette.mauve,     -- #CBA6F7
  orange      = catppuccin_palette.peach,     -- #FAB387
  lightOrange = catppuccin_palette.rosewater, -- #F5E0DC
  yellow      = catppuccin_palette.yellow,    -- #F9E2AF
  black       = catppuccin_palette.crust,     -- #11111B
  lightBlack  = catppuccin_palette.mantle,    -- #181825
  background  = catppuccin_palette.base,      -- #1E1E2E
  gray        = catppuccin_palette.surface1,  -- #45475A
  lightGray1  = catppuccin_palette.overlay0,  -- #6C7086
  lightGray2  = catppuccin_palette.overlay1,  -- #7F849C
  lightGray3  = catppuccin_palette.overlay2,  -- #9399B2
  lightGray4  = catppuccin_palette.subtext0,  -- #A6ADC8
  darkWhite   = catppuccin_palette.subtext1,  -- #BAC2DE
  white       = catppuccin_palette.text,      -- #CDD6F4
}


-- git sign colors
-- vim.cmd("highlight GitSignsAdd guibg=NONE guifg=" .. green)
-- vim.cmd("highlight GitSignsChange guibg=NONE guifg=" .. lightBlue)
-- vim.cmd("highlight GitSignsChangeDelete guibg=NONE guifg=" .. lightBlue)
-- vim.cmd("highlight GitSignsDelete guibg=NONE guifg=" .. red)
-- vim.cmd("highlight GitSignsTopDelete guibg=NONE guifg=" .. red)
-- vim.cmd("highlight GitSignsUntracked guibg=NONE guifg=" .. orange)

-- Make :%s more visible
vim.cmd.highlight("Substitute guibg=" .. Colors["pink"] .. " guifg=" .. Colors["gray"])

-- Lighter colors for transparent window
vim.cmd.highlight("LineNr guibg=NONE guifg=" .. Colors["lightGray1"])
vim.cmd.highlight("Comment guibg=NONE guifg=" .. Colors["lightOrange"]) --lightGray3
vim.cmd.highlight("Visual guibg=" .. Colors["lightGray1"])


-- lsp colors
vim.cmd("highlight DiagnosticVirtualTextError guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextWarn guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextInfo guibg=NONE")
vim.cmd("highlight DiagnosticVirtualTextHint guibg=NONE")

-- Indent signs
vim.cmd("highlight IndentBlanklineChar guifg=" .. Colors["lightBlack"])             -- Indent line : very dark comments
vim.cmd("highlight IndentBlanklineContextChar guifg=" .. Colors["gray"])            -- Current indent line
vim.cmd("highlight IndentBlanklineSpaceChar guifg=" .. Colors["lightGray1"])        -- space
vim.cmd("highlight IndentBlanklineContextSpaceChar guifg=" .. Colors["lightGray1"]) -- space

-- Dap
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = Colors["red"], bg = '' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = Colors["blue"], bg = '' })

-- DapUI
vim.cmd("highlight DapUIBreakpointsDisabledLine guifg=" .. Colors["lightBlack"])
vim.cmd("highlight DapUIBreakpointsCurrentLine guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUICurrentFrameName guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIBreakpointsPath guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIBreakpointsLine guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIBreakpointsInfo guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIUnavailableNC guifg=" .. Colors["lightBlack"])
vim.cmd("highlight DapUIStoppedThread guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIModifiedValue guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIWatchesValue guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIWatchesError guifg=" .. Colors["red"])
vim.cmd("highlight DapUIWatchesEmpty guifg=" .. Colors["red"])
vim.cmd("highlight DapUIUnavailable guifg=" .. Colors["lightBlack"])
vim.cmd("highlight DapUIPlayPauseNC guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIFloatNormal guifg=" .. Colors["white"])
vim.cmd("highlight DapUIFloatBorder guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIEndofBuffer guifg=" .. Colors["white"])
vim.cmd("highlight DapUIStepOverNC guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIStepIntoNC guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIStepBackNC guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUILineNumber guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIDecoration guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIWinSelect guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIStepOutNC guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIRestartNC guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIPlayPause guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIFrameName guifg=" .. Colors["white"])
vim.cmd("highlight DapUIVariable guifg=" .. Colors["white"])
vim.cmd("highlight DapUIStepOver guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIStepInto guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIStepBack guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUINormalNC guifg=" .. Colors["white"])
vim.cmd("highlight DapUIStepOut guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIRestart guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIThread guifg=" .. Colors["lightGreen"])
vim.cmd("highlight DapUIStopNC guifg=" .. Colors["red"])
vim.cmd("highlight DapUISource guifg=" .. Colors["purple"])
vim.cmd("highlight DapUINormal guifg=" .. Colors["white"])
vim.cmd("highlight DapUIValue guifg=" .. Colors["white"])
vim.cmd("highlight DapUIScope guifg=" .. Colors["lightBlue"])
vim.cmd("highlight DapUIType guifg=" .. Colors["purple"])
vim.cmd("highlight DapUIStop guifg=" .. Colors["red"])

-- Marks
vim.cmd("highlight MarkSignHL gui=bold guifg=" .. Colors["yellow"])


-- Transparency handled by theme
-- vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]
-- transparent background
-- vim.cmd [[highlight SignColumn guibg=NONE]] -- Sign column has same color as number column

return Colors -- Can be used with require("colorscheme")
