-- Set lualine as statusline
-- See `:help lualine.txt`
--
--
--

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "auto",                               -- use nvim theme
    disabled_filetypes = { 'alpha', 'NvimTree' }, -- disable statusline on these files
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
      },
      -- LSP status
      function()
        return require("lsp-progress").progress({
          format = function(messages)                -- messages variable format is defined in .setup fn (bottom)
            if #messages > 0 then
              return "󰲼 LSP " .. messages[#messages] -- show last message
            end
            local clients = GetBufferLSPs()
            if #clients == 0 then
              return ""
            end

            local lsps = {}
            for i, client in ipairs(clients) do
              lsps[i] = client.name
            end
            return "󰦕 LSP [" .. table.concat(lsps, " | ") .. "]"
          end
        })
      end
    },
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
      end,
      'filetype',
    },
    lualine_y = { 'progress' }, -- percentage in file
    lualine_z = { 'location' }  -- line : character
  },
}

-- refresh lualine for lsp status
vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])


require("lsp-progress").setup({
  spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  -- spinner = { "◜", "◠", "◝", "◞", "◡", "◟", },
  spin_update_time = 150,
  client_format = function(client_name, spinner, series_messages)
    -- shown when lsp is messaging
    if #series_messages > 0 then
      for _, act_client in ipairs(GetBufferLSPs()) do
        if act_client.name == client_name then
          local lastMsg = series_messages[#series_messages]
          return "[" .. client_name .. "] " .. spinner .. " " .. lastMsg
        end
      end
    end
    return ""
  end,
})
