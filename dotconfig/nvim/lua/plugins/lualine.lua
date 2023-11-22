-- Set lualine as statusline
-- See `:help lualine.txt`
--
--
--
--
local function min_window_width(width)
  return function() return vim.fn.winwidth(0) > width end
end


local lightGray = GetHex("Comment", "fg")
local blackColor = GetHex("CursorColumn", "bg")
local green = GetHex("DiagnosticOk", "fg")
local red = GetHex("Error", "fg")
local orange = GetHex("Constant", "fg")

local icons = require("../icons").lspSigns
local autoFormatIcon = "AF" -- 󰽎 󰷲 󰁨       󰉩 󰃢

-- Mode
local mode_map = {
  ['NORMAL'] = "N",
  ['O-PENDING'] = 'N?',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-BLOCK'] = 'VB',
  ['V-LINE'] = 'VL',
  ['V-REPLACE'] = 'VR',
  ['REPLACE'] = 'R',
  ['COMMAND'] = '!',
  ['SHELL'] = 'SH',
  ['TERMINAL'] = 'T',
  ['EX'] = 'X',
  ['S-BLOCK'] = 'SB',
  ['S-LINE'] = 'SL',
  ['SELECT'] = 'S',
  ['CONFIRM'] = 'Y?',
  ['MORE'] = 'M',
}



require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "auto",                               -- use nvim theme
    disabled_filetypes = { 'alpha', 'NvimTree' }, -- disable statusline on these files
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', fmt = function(s) return mode_map[s] or s end } },
    lualine_b = {
      { 'branch', cond = min_window_width(90) },
      'diff',
      {
        function()
          local buf = vim.api.nvim_win_get_buf(0)
          if vim.bo[buf].readonly then
            return "READONLY"
          else
            return ""
          end
        end,
        color = { fg = orange },
      }
    },
    lualine_c = {
      {
        'diagnostics',
        symbols = { error = icons.Error, warn = icons.Warn, info = icons.Info, hint = icons.Hint },
      },
      {
        function()                                               -- print the todo count (in comments)
          local comment = string.sub(vim.o.commentstring, 0, -4) -- get the comment pattern : "# %s" -> "#"
          local todos = vim.fn.searchcount({ pattern = comment .. ".*TODO:", recompute = 1 }).total
          if todos > 0 then
            return " " .. todos
          end
          return ""
        end,
        color = { fg = "#89dceb" },
      },
      -- LSP status
      function()
        return require("lsp-progress").progress({
          format = function(messages) -- messages variable format is defined in .setup fn (bottom)
            if #messages > 0 then
              return "󰲼 LSP " .. messages[#messages] -- show last message
            end

            -- No current messages :
            local clients = GetBufferLSPs()
            if #clients == 0 then
              return ""
            end

            local lsps = {}
            for i, client in ipairs(clients) do
              lsps[i] = client.name
            end
            local runningLsp = "󰦕 LSP ["
            runningLsp = runningLsp .. table.concat(lsps, " | ")
            if GetConformFormatters() ~= "" then
              if #lsps > 0 then
                runningLsp = runningLsp .. " | "
              end
              runningLsp = runningLsp .. GetConformFormatters()
            end
            runningLsp = runningLsp .. "]"
            if #runningLsp + 65 > vim.fn.winwidth(0) then
              runningLsp = "󰦕 LSP"
            end
            return runningLsp
          end
        })
      end
    },
    lualine_x = {
      {
        -- autoformat enabled
        function()
          if vim.b.autoformat then
            return autoFormatIcon
          else
            return ""
          end
        end,
        separator = "",
        color = { fg = green }
      },
      {
        -- autoformat disabled
        function()
          if vim.b.autoformat then
            return ""
          else
            return autoFormatIcon
          end
        end,
        separator = "",
        color = { fg = red }
      },
      {
        function() return '' end,
        separator = "",
        padding = { left = 1, right = 0 },
        color = { fg = blackColor }
      },
      {
        'filetype',
        color = { bg = blackColor }
      },
      {
        function()
          -- tab size
          if vim.o.expandtab then -- if use space for tab
            return " " .. vim.o.shiftwidth
          else
            return " TAB"
          end
        end,
        color = { bg = blackColor, fg = lightGray }
      },
      {
        'fileformat',
        symbols = {
          unix = " LF", -- e712
          dos = " CRLF", -- e70f
          mac = " CR", -- e711
        },
        color = { bg = blackColor, fg = lightGray }
      },
      --[[
      {
        -- wrapping
        function()
          -- Wrapping 󰯟  󰖶  󰴏  󰴐 󱞱 󱞲 →   󰞘 󰜴
          if (vim.o.wrap == true) then
            return "󱞲"
          else
            return "󰞘"
          end
        end,
        color = { bg = blackColor, fg = lightGray }
      },
      ]]
      {
        function() return '' end,
        padding = { left = 0, right = 1 },
        color = { fg = blackColor }
      },
    },
    lualine_y = { {
      --[[
      -- Manual "progress" in file just to disable "Top" and "Bot"
      function()
        if vim.fn.line("w0") == 1 and vim.fn.line("$") <= vim.api.nvim_win_get_height(0) then -- all text is visible
          return ""
        end
        return " " ..
            math.floor(vim.fn.line(".") / vim.fn.line("$") * 100) ..
            "%%" -- double percent because of string.format() used by lualine
      end,
      ]]
      function()
        return "󰉸 " .. vim.fn.line("$") --󰉸  󰦪 󰉠 󰦨 ≡ 󰍜  k
      end,
    } },
    lualine_z = { {
      function()
        return "󱎦" .. vim.fn.line(".") .. "󰫰" .. vim.fn.virtcol('.')
      end,
      padding = { left = 0, right = 1 }
    } }
    -- lualine_z = { 'location' }  -- line : character
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
  spin_update_time = 100,
  client_format = function(client_name, spinner, series_messages)
    -- shown when lsp is messaging
    if #series_messages > 0 then
      for _, act_client in ipairs(GetBufferLSPs()) do
        if act_client.name == client_name then
          if client_name == "conform" then
            client_name = GetConformFormatters()
          end
          local lastMsg = series_messages[#series_messages]
          return "[" .. client_name .. "] " .. spinner .. " " .. lastMsg
        end
      end
    end
    return ""
  end,
})
