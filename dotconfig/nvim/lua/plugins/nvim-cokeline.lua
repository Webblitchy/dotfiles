local unselected_color = GetHex("Comment", "fg")

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
      return buffer.is_focused and buffer.diagnostics.errors ~= 0 and GetHex("DiagnosticError", "fg")
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
          and GetHex('Normal', 'fg')
          or unselected_color
    end,
    bg = function(buffer)
      return GetHex("CursorColumn", "bg") -- same color as the rest of the bar
    end,
  },
  sidebar = {
    filetype = 'NvimTree',
    components = {
      {
        text = function(buf)
          return buf.filetype
        end,
        fg = GetHex('Boolean', 'fg'), -- orange
        bg = "none",
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
