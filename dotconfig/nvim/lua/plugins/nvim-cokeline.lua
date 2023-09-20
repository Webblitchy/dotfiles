local get_hex = require('cokeline/utils').get_hex
local unselected_color = get_hex("Comment", "fg")

local components = {
  space = {
    text = ' ',
    truncation = { priority = 1 }
  },
  separator = {
    text = function(buffer)
      return buffer.index ~= 1 and '▏'
          or ''
    end,
    fg = unselected_color,
    truncation = { priority = 1 }
  },
  devicon = {
    text = function(buffer)
      return buffer.devicon.icon
    end,
    fg = function(buffer)
      return buffer.is_focused and buffer.devicon.color or unselected_color
    end,
    truncation = { priority = 1 }
  },
  filename = {
    text = function(buffer)
      return buffer.unique_prefix .. buffer.filename
    end,
    bold = function(buffer)
      return buffer.is_focused
    end,
    fg = function(buffer)
      return buffer.is_focused and buffer.diagnostics.errors ~= 0 and get_hex("DiagnosticError", "fg")
          or nil
    end,
    truncation = {
      priority = 2,
      direction = 'left',
    },
  },
  unsaved = {
    text = function(buffer)
      return buffer.is_modified and require("../icons").modified
          or " "
    end,
    fg = function(buffer)
      return not buffer.is_focused and unselected_color or nil
    end,
    truncation = { priority = 1 },
  },
}

require('cokeline').setup({
  buffers = {
    filter_valid = function(buffer)
      -- get buffertype with ":echo &buftype"
      return buffer.type ~= "terminal"  -- hide terminal type
          and buffer.type ~= "quickfix" -- quickfix list
    end,
  },
  rendering = {
    max_buffer_width = 30,
  },
  default_hl = {
    fg = function(buffer)
      return
          buffer.is_focused
          and get_hex('Normal', 'fg')
          or get_hex('Comment', 'fg')
    end,
    bg = function(buffer)
      return require("catppuccin.palettes.mocha").mantle -- same color as the rest of the bar
    end,
  },
  sidebar = {
    filetype = 'NvimTree',
    components = {
      {
        text = function(buf)
          return buf.filetype
        end,
        fg = get_hex('Boolean', 'fg'),
        bg = function() return get_hex('NvimTreeNormal', 'bg') end,
        bold = true,
      },
    }
  },
  components = {
    components.space,
    components.separator,
    components.space,
    components.devicon,
    components.space,
    components.filename,
    components.space,
    components.unsaved,
    components.space,
  },
})
