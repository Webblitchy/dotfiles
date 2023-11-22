-- [ AUTO CMD ]

local autocmd = vim.api.nvim_create_autocmd

local goodScrollOff = math.ceil(vim.api.nvim_win_get_height(0) / 4)

-- [[ CURSOR AUTO COMMANDS ]]
--
-- always have a 1/4 of the screen of margin after / before the cursor
autocmd({ "VimResized", "VimEnter", "WinEnter", "WinLeave", "BufEnter" }, {
  callback = function()
    -- normal buffer (not terminal or prompt or NvimTree)
    if vim.bo.buftype ~= "" then
      return
    end

    vim.wo.scrolloff = goodScrollOff
  end
})

-- Restore cursor position when opening a file
autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function()
    local oldLine = vim.fn.line("'\"")
    local lastLine = vim.fn.line("$")
    if (oldLine > 1 and oldLine <= lastLine) then
      vim.api.nvim_command("normal! g'\"")
    end
  end
})


-- Keep space at the bottom of a file
autocmd({ "CursorMoved" }, {
  callback = function(args)
    -- normal buffer (not terminal or prompt or NvimTree)
    if vim.bo.buftype ~= "" then
      return
    end

    -- disabled when debugging
    if require("dap").status() ~= "" then
      return
    end

    local windowLines = vim.api.nvim_win_get_height(0)
    local currLine = vim.fn.line(".")
    local lastLine = vim.fn.line("$")

    -- to handle a file smaller than window
    local bottom = 0
    if windowLines > lastLine then
      bottom = windowLines
    else
      bottom = lastLine
    end

    local marginBottom = currLine + vim.o.scrolloff - bottom
    if marginBottom == 0 then
      vim.api.nvim_input("zb")                    -- align cursor with bottom of file
    elseif marginBottom > 0 then
      vim.api.nvim_input("zb")                    -- align cursor with bottom of file
      vim.api.nvim_input(marginBottom .. "<C-E>") -- scroll down
    end
  end,
})


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- Info when search made a full circle (use a keymap with n)
vim.b.currentSearch = ""
autocmd("CmdlineLeave", {
  callback = function()
    if vim.v.event.cmdtype == "/" and vim.fn.getcmdline() ~= vim.b.currentSearch then
      vim.b.searchStartPos = 0
      vim.b.currentSearch = vim.fn.getcmdline()
      -- Maybe useful
    end
    if vim.v.event.cmdtype == "/" then
      -- vim.api.nvim_input(":echo '" .. vim.fn.getcmdline() .. "' <CR>")
    end
  end
})

--------------------------------------------------------
--
-- [[ TERMINAL AUTO COMMANDS ]]

-- replace term in new tab default behavior
local hideBordersCommand = "set nonumber | set norelativenumber | set signcolumn=no"
local showBordersCommand = "set number | set relativenumber | set signcolumn=yes"

autocmd("TermOpen", {
  callback = function()
    local buffname = vim.api.nvim_buf_get_name(0)
    if not string.find(buffname, "term:") then
      return -- to disable behavior with debugger (dap-terminal)
    end
    local termSize = math.ceil(vim.api.nvim_win_get_height(0) / 3)
    vim.api.nvim_command("sp #") -- reopen textfile above

    -- must be input mode (to be executed when terminal is opened):
    vim.api.nvim_input(":res " .. termSize .. "<CR>")
    vim.api.nvim_input(":" .. hideBordersCommand .. "<CR>")
    ClearCommandLine()

    -- vim.opt_local.laststatus = 0 -- disable statusline (lualine in my case)
    vim.opt_local.showmode = false
    vim.opt_local.shortmess:append({ F = true })
    vim.api.nvim_input('a') -- interactive mode
  end
})

autocmd("TermClose", {
  callback = function()
    -- Auto close terminal (hide result of ^x)

    -- vim.api.nvim_input("<C-Y>") -- scroll up (directly quit terminal without status)
    -- vim.api.nvim_input("zz")    -- center cursor
  end
})


-----------------------------------------------------------

-- create templates for files types
local templates = {
  -- file extention: ask confirmation
  sh = false,
  c = true,
  cpp = true,
}

for language, askConfirmation in pairs(templates) do
  autocmd("BufNewFile", {
    callback = function()
      if askConfirmation then
        local res = vim.fn.input("Do you want to fill new file with template ? [y/N] : ")
        if string.lower(res) ~= "y" then
          return
        end
      end
      local templatePath = GetConfigFolder() .. "/lua/templates/template." .. language
      vim.api.nvim_input(":0r " .. templatePath .. "<CR>") -- insert template file
      ClearCommandLine()
    end,
    pattern = "*." .. language
  })
end


-- [[ Add missing filetypes association ]]
local filetypes = require("filetype_association")
for ft, pattern in pairs(filetypes) do
  autocmd({ "BufRead", "BufNewFile" }, {
    callback = function()
      vim.opt_local.filetype = ft
    end,
    pattern = pattern
  })
end
------------------------


local disabledAFByDefault = {
  "html"
}

-- autoformat on save
vim.b.autoformat = false -- false by default
autocmd("LspAttach", {
  callback = function(args)
    -- local bufnr = args.buf
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- print("lsp attached " .. client.name)

    -- Disabled autoFormat by default
    local bufNbr = vim.api.nvim_get_current_buf()
    local bufFiletype = vim.api.nvim_buf_get_option(bufNbr, "filetype")
    if IsIn(bufFiletype, disabledAFByDefault) then
      return
    end

    if CanFormat() then
      vim.b.autoformat = true
    end
  end
})

autocmd("BufWritePre", {
  callback = function()
    if vim.b.autoformat then
      FormatOnSave()
    end
  end
})



-- Disable caps lock when leaving insert mode
autocmd("InsertLeave", {
  callback = function()
    local capState = vim.fn.matchstr(vim.fn.system('xset -q'), '00: Caps Lock:\\s\\+\\zs\\(on\\|off\\)\\ze')
    if capState == "on" then
      vim.api.nvim_exec("silent! execute ':!xdotool key Caps_Lock'", false) -- toggle capslock
    end
  end
})


-- Auto open nvim-tree when opening a folder
autocmd({ "VimEnter" }, {
  callback = function(data)
    -- buffer is not a directory
    if vim.fn.isdirectory(data.file) ~= 1 then
      return
    end

    vim.cmd.cd(data.file)                -- change to the directory
    require("nvim-tree.api").tree.open() -- open the tree
  end
})


-- Auto source files in nvim config
--[[
autocmd({ "BufWritePost" }, {
  callback = function(data)
    -- local configFolder = vim.fn.stdpath("config") -- don't give .dotconfig path
    local configFolder = GetConfigFolder()
    if string.find(data.match, "plugin_installation") then
      return
    end -- avoid bugs
    if string.find(data.match, configFolder) then
      vim.api.nvim_input(":source %<CR>")
      vim.api.nvim_input(":<BS>")
    end
  end,
  pattern = "*.lua"
})
]]


-- Open help in a new buffer
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "help" then
      vim.bo.buflisted = true -- can be in the bufferlist
      vim.cmd.only()          -- quit all window (not buffer) except the current one
    end
  end,
})


-- Go to error from quickfix
autocmd("FileType", {
  pattern = { "qf" },
  callback = function()
    vim.keymap.set("n", "<CR>", ":.cc<CR>", { silent = true, buffer = true })
  end
})

-- Handle ScrollBar display
autocmd({ "BufEnter", "OptionSet" }, {
  callback = function()
    if vim.wo.wrap then
      require("scrollbar.utils").hide()
    else
      require("scrollbar.utils").show()
    end
  end
})


-- Hide cursor for NvimTree
local default_guicursor = vim.go.guicursor
-- local default_cursorlineopt = vim.go.cursorlineopt
vim.api.nvim_create_autocmd({ "BufEnter", "UIEnter" }, {
  callback = function()
    if vim.bo.filetype == "NvimTree" then
      vim.go.guicursor = "a:HiddenCursor"
      -- elseif vim.bo.filetype == "alpha" then
      -- not working
      --   vim.go.guicursor = "a:HiddenCursor"
      --   vim.go.cursorlineopt = "line"
    else
      vim.go.guicursor = default_guicursor
      -- vim.go.cursorlineopt = default_cursorlineopt
    end
  end
})


-----------------------------------------
-- [ NEW USER COMMANDS ]

function ToggleMouse()
  if vim.go.mouse == "" then
    vim.o.mouse = "nvi"
    print("Mouse enabled")
    ClearCmdIn2secs()
  else
    vim.o.mouse = ""
    print("Mouse disabled")
    ClearCmdIn2secs()
  end
end

vim.api.nvim_create_user_command(
  "M",
  "lua ToggleMouse()",
  {}
)

function ToggleAutoFormat()
  if not CanFormat() then
    print("No formatter defined")
    ClearCmdIn2secs()
    return
  end

  if vim.b.autoformat then
    print("Autoformat disabled")
  else
    print("Autoformat enabled")
  end
  ClearCmdIn2secs()
  vim.b.autoformat = not vim.b.autoformat
end

vim.api.nvim_create_user_command(
  "ToggleAutoFormat",
  "lua ToggleAutoFormat()",
  {}
)

vim.api.nvim_create_user_command(
  "AF",
  "lua ToggleAutoFormat()",
  {}
)


-- Save with sudo (requires Suda plugin)
vim.api.nvim_create_user_command(
  "W",
  "SudaWrite",
  {}
)

-- Open with sudo (requires Suda plugin)
vim.api.nvim_create_user_command(
  "R",
  "SudaRead",
  {}
)

-- Update all mason packages
vim.api.nvim_create_user_command(
  "MasonUpdateAll",
  'exec "normal :Mason\\<CR>" | sleep 1000ms | normal U', -- exec to use <CR>
  {}
)

-- Show filepath
vim.api.nvim_create_user_command(
  "PWD",
  "lua print(vim.api.nvim_buf_get_name(0))",
  {}
)


-- Preview markdown in okular with :MD
vim.cmd [[command! -complete=shellcmd -nargs=1 -bang Silent execute ':silent !' . (<bang>0 ? 'nohup ' . <q-args> . '</dev/null >/dev/null 2>&1 &' : <q-args>) | execute ':redraw!']]
vim.cmd [[command! MD w | Silent! okular %:S]]
