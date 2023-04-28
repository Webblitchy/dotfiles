-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "auto",                                -- use nvim theme
    disabled_filetypes = { 'packer', 'NvimTree' }, -- disable statusline on these files
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      'branch',
      'diff'
    },
    lualine_c = {
      'diagnostics',
      {
        function()                                               -- print the todo count (in comments)
          local comment = string.sub(vim.o.commentstring, 0, -4) -- get the comment pattern : "# %s" -> "#"
          local todos = vim.fn.searchcount({ pattern = comment .. ".*TODO:", recompute = 1 }).total
          if todos > 0 then
            return " " .. todos
          end
          return ""
        end,
        color = { fg = "#add8e6" }
      }
    },
    -- lualine_c = {
    --   {
    --     'filename',
    --     color = { fg = '#fabd2f' },
    --     path = 3 -- abs path
    --   },
    -- },
    lualine_x = {
      {
        'fileformat',
        symbols = {
          unix = " LF", -- e712
          dos = " CRLF", -- e70f
          mac = " CR", -- e711
        }
      },
      function() -- wrapping
        -- Wrapping 󰯟  󰖶  󰴏  󰴐 󱞱 󱞲 →   󰞘 󰜴
        local wrapMode = ""
        if (vim.o.wrap == true) then
          wrapMode = wrapMode .. "󱞲"
        else
          wrapMode = wrapMode .. "󰞘"
        end
        return wrapMode
      end,
      function()                -- tab size
        if vim.o.expandtab then -- if use space for tab
          return " " .. vim.o.shiftwidth
        else
          return " TAB"
        end
        --
      end,
      'filetype',
    },
    lualine_y = { 'progress' }, -- percentage in file
    lualine_z = { 'location' }  -- line, character
  },
}
