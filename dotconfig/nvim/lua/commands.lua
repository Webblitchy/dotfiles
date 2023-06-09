-- [ AUTO CMD ]

local autocmd = vim.api.nvim_create_autocmd

-- always have a 1/4 of the screen of margin after / before the cursor
autocmd({ "VimResized", "VimEnter", "WinLeave" }, {
  callback = function()
    vim.wo.scrolloff = math.ceil(vim.api.nvim_win_get_height(0) / 4)
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
  callback = function()
    -- normal buffer (not terminal or prompt)
    if vim.bo.buftype ~= "" then
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
    -- vim.opt_local.laststatus = 2 -- reenable statusline
    -- vim.api.nvim_input("<C-Y>") -- scroll up (directly quit terminal without status)
  end
})



-- insert bin bash for new shell files
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
    end,
    pattern = "*." .. language
  })
end


-- [[ Add missing filetypes ]]
local filetypes = {
  scala = "*.worksheet.sc",
  sage = "*.sage",
  config = { "*.conf", "*.config" },
  sh = { "*.zsh" }
}

for ft, pattern in pairs(filetypes) do
  autocmd({ "BufRead", "BufNewFile" }, {
    callback = function()
      vim.opt_local.filetype = ft
    end,
    pattern = pattern
  })
end
------------------------


-- autoformat on save
autocmd("BufWritePre", {
  callback = function()
    FormatOnSave()
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


-- Preview markdown in okular with :MD
vim.cmd [[command! -complete=shellcmd -nargs=1 -bang Silent execute ':silent !' . (<bang>0 ? 'nohup ' . <q-args> . '</dev/null >/dev/null 2>&1 &' : <q-args>) | execute ':redraw!']]
vim.cmd [[command! MD w | Silent! okular %:S]]
