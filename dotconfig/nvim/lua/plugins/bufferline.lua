require("bufferline").setup {
  options = {
    indicator = {
      style = "none",
    },
    separator_style = "thin", -- { "", "" },
    modified_icon = "󰛄",
    color_icons = true,
    show_buffer_close_icons = false,
    max_name_length = 30,
    diagnostics = "nvim_lsp",
    offsets = {
      {
        filetype = "NvimTree",
        text = "NvimTree",
        highlight = "Directory",
        separator = true
      }
    }
  },

  highlights = {
    -- background
    fill = {
      -- bg = require("gruvbox.palette").colors.dark1
      bg = "" -- transparent
    },
    -- unselected buffers
    background = {
      bg = require("gruvbox.palette").colors.dark1
    },
    modified = {
      bg = require("gruvbox.palette").colors.dark1,
      fg = require("gruvbox.palette").colors.light4,
    },
    separator = {
      bg = require("gruvbox.palette").colors.dark1,
    },
    diagnostic = {
      bg = require("gruvbox.palette").colors.dark1,
    },
    warning = {
      bg = require("gruvbox.palette").colors.dark1,
    },
    error = {
      bg = require("gruvbox.palette").colors.dark1,
    },
    hint = {
      bg = require("gruvbox.palette").colors.dark1,
    },
    duplicate = {
      bg = require("gruvbox.palette").colors.dark1,
      fg = require("gruvbox.palette").colors.light4,
      italic = false
    },
    -- selected buffer
    buffer_selected = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.light1,
      italic = false
    },
    modified_selected = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.light1
    },
    separator_selected = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    indicator_selected = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    warning_selected = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.bright_yellow,
    },
    error_selected = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    hint_selected = {
      bg = require("gruvbox.palette").colors.dark3,
      italic = false
    },
    duplicate_selected = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.light1,
      italic = false
    },
    -- selected buffer without focus
    buffer_visible = {
      bg = require("gruvbox.palette").colors.dark3
    },
    modified_visible = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.light4,
    },
    separator_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    indicator_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    diagnostic_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    warning_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    error_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    hint_visible = {
      bg = require("gruvbox.palette").colors.dark3,
    },
    duplicate_visible = {
      bg = require("gruvbox.palette").colors.dark3,
      fg = require("gruvbox.palette").colors.light4,
      italic = false
    }
  }
}
