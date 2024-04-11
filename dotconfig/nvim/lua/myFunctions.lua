-- [[ UTILS ]]

function IsIn(element, table)
  for _, value in ipairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function File_exists(name)
  -- function taken from real source code
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function Keycode(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

function ClearCommandLine()
  vim.api.nvim_input(":<BS>")
end

function ClearCmdIn2secs()
  vim.fn.timer_start(2000, function()
    vim.api.nvim_command("echo ''")
  end)
end

function GetConfigFolder()
  return vim.fn.fnamemodify(vim.env.MYVIMRC, ":p:h")
end

function GetBufferLSPs(bufNbr)
  bufNbr = bufNbr or vim.api.nvim_get_current_buf() -- default is current buf

  local lsps = vim.lsp.get_active_clients({ bufnr = bufNbr })
  -- resolve a bug for lsp at index 2
  local lspsReindexed = {}
  for _, v in pairs(lsps) do
    lspsReindexed[#lspsReindexed + 1] = v
  end
  return lspsReindexed
end

function GetConformFormatters()
  local formatters = {}
  for i, formatter in ipairs(require("conform").list_formatters()) do
    formatters[i] = formatter.name
  end
  return table.concat(formatters, " | ") -- return "" if no formatters
end

function GetParentFolderPath()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
end

function GetParentFolderName()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h:t")
end

function PrettyPath(remainingSpace)
  -- stole function from lualine.nvim

  local sep = package.config:sub(1, 1)

  local path = vim.fn.expand('%:p:~') -- absolute path, with tilde

  local max_len = vim.fn.winwidth(0) - remainingSpace

  local len = #path
  if len <= max_len then
    return path
  end

  local segments = vim.split(path, sep)
  for idx = 1, #segments - 1 do
    if len <= max_len then
      break
    end

    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
    segments[idx] = shortened
    len = len - (#segment - #shortened)
  end

  return table.concat(segments, sep)
end

-- Maybe usefull (timer)
function Timer()
  local timer = vim.loop.new_timer()
  local i = 0
  -- Waits 3000ms, then repeats every 1000ms until timer:close().
  timer:start(3000, 1000, function()
    if i > 30 then -- try max during 30s
      timer:close()
    end
    i = i + 1
  end)
end

-- Maybe usefull
function ExecuteAfter(ms, f)
  local timer = vim.loop.new_timer()
  timer:start(ms, 0, function()
    vim.schedule(f)
    timer:close()
  end)
end

function BlocAsync(f)
  -- Wait for 5 seconds or until function ended, checking every ~300 ms
  vim.wait(5000, f, 300)
end

function GetHex(hl, fgOrBg)
  local rgb = vim.api.nvim_get_hl(0, { name = hl })[fgOrBg]

  local band, lsr = bit.band, bit.rshift

  local r = lsr(band(rgb, 0xff0000), 16)
  local g = lsr(band(rgb, 0x00ff00), 8)
  local b = band(rgb, 0x0000ff)

  local res = ("#%02x%02x%02x"):format(r, g, b)
  return res
end

-- [[ Big functions ]]

function AutoCompile(debugMode)
  local filePath = '"' .. vim.api.nvim_buf_get_name(0) .. '"'
  local fileType = vim.bo.filetype

  local parentFolderPath = GetParentFolderPath()
  local parentFolderName = GetParentFolderName()

  local function executeFile(command)
    local fullCommand = "cd '" .. parentFolderPath .. "' && " .. command
    if debugMode then
      -- do in the background
      vim.fn.system(fullCommand)
    else
      -- do in the foreground to show result in terminal
      vim.api.nvim_command("term " .. fullCommand)
    end
  end

  if fileType == "python"
      or fileType == "lua"
      or fileType == "java"
      or fileType == "scala"
      or fileType == "sage" then
    executeFile(fileType .. " " .. filePath)
  elseif fileType == "rust" then
    if debugMode then
      executeFile("cargo build") -- maybe change
    else
      executeFile("cargo run")
    end
  elseif fileType == "sh" then
    executeFile("bash < " .. filePath)
  elseif fileType == "javascript" then
    executeFile("node " .. filePath)
  elseif fileType == "c" then
    -- (always link math lib for simplicity)
    local compile = "clang "
    if debugMode then
      -- Compile with debug symbols (with -g)
      compile = compile .. "-g "
    end
    compile = compile .. "-c *.c && clang *.o -lm -g -o '" .. parentFolderName .. "' ; rm *.o"
    executeFile(compile .. " && './" .. parentFolderName .. "'")
  elseif fileType == "cpp" then
    local compile = "clang++ "
    if debugMode then
      -- Compile with debug symbols (with -g)
      compile = compile .. "-g "
    end
    compile = compile .. "-c *.cpp && clang++ *.o -o '" .. parentFolderName .. "' ; rm *.o"
    executeFile(compile .. " && './" .. parentFolderName .. "'")
  end
end

function ConvertFileFormat(format)
  format = string.lower(format)
  if format == "linux" or format == "unix" or format == "lf" then
    format = "unix"
  elseif format == "dos" or format == "windows" or format == "crlf" then
    format = "dos"
  elseif format == "mac" or format == "cr" then
    format = "mac"
  else
    print("Unknown format")
    return
  end

  vim.cmd.update() -- write only if changes
  vim.opt_local.ff = format
  vim.cmd.write()
end

function CanFormat()
  local bufNbr = vim.api.nvim_get_current_buf()

  if not vim.lsp.buf.server_ready() then -- only on current buffer
    return false
  end

  local bufFiletype = vim.api.nvim_buf_get_option(bufNbr, "filetype")


  if GetBufferLSPs(bufNbr)[1].server_capabilities.documentFormattingProvider -- can format with LSP
      or #require("conform").list_formatters(bufNbr) > 0 then
    return true
  end
  return false
end

function FormatOnSave()
  if not CanFormat() then
    return
  end

  local bufNbr = vim.api.nvim_get_current_buf()

  if GetBufferLSPs()[1].server_capabilities.documentFormattingProvider then -- can format with LSP
    local lspState = vim.lsp.util.get_progress_messages()[1]
    if lspState ~= nil then                                                 -- if has progress messages
      if not lspState.done then                                             -- saying the server isn't ready
        return
      end
    end
    vim.lsp.buf.format({ async = false }) -- is async so it can save before quitting
  elseif #require("conform").list_formatters(bufNbr) > 0 then
    require("conform").format({ async = false })
  end
  -- when saving with :wq
  -- if vim.lsp.buf.server_ready()
  --     and IsSaving ~= true then -- format only once
  --   local timer = vim.loop.new_timer()
  --   IsSaving = true
  --   -- doesn't work with :wq
  --   timer:start(0, 600, vim.schedule_wrap(function()
  --     if vim.lsp.util.get_progress_messages()[1] == nil then -- when lsp is ready
  --       vim.lsp.buf.format({ async = false }) -- is async because in schedule wrap
  --       vim.cmd.write()
  --       timer:stop()
  --     --
  --       IsSaving = false
  --       return
  --     end
  --   end))
  -- end
end

-- returns a dictionnary of all added words (with zg)
function CustomDictionnary()
  local path = vim.go.spellfile -- already contains full path
  local words = {}


  if vim.fn.filereadable(path) ~= 0 then -- if file exists
    for word in io.open(path, "r"):lines() do
      table.insert(words, word)
    end
  end

  return words
end

function ToggleGlobalMark()
  local globalMarks = {}
  for _, v in ipairs(vim.fn.getmarklist()) do
    local buf, line, _, _ = unpack(v.pos)
    local mark = string.sub(v.mark, 2, 3)

    -- disable mark if found
    if buf == vim.api.nvim_get_current_buf() -- on current buffer
        and line == vim.fn.line(".")         -- on current line
        and mark:match("%u") then            -- select only uppercase characters
      vim.api.nvim_del_mark(mark)
      return
    end

    globalMarks[mark] = true
  end

  local smallestUpper = "A"
  while smallestUpper ~= "[" do -- char after "Z"
    if globalMarks[smallestUpper] ~= true then
      vim.api.nvim_buf_set_mark(vim.api.nvim_get_current_buf(), smallestUpper, vim.fn.line("."), vim.fn.virtcol("."), {})
      return
    end
    smallestUpper = string.char(smallestUpper:byte() + 1)
  end
  print("There is not more Global Mark available")
end

function DeleteMark()
  local marklist = vim.fn.extend(vim.fn.getmarklist(), vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
  for _, v in ipairs(marklist) do
    local buf, line, _, _ = unpack(v.pos)
    local mark = string.sub(v.mark, 2, 3)

    -- disable mark if found
    if buf == vim.api.nvim_get_current_buf()
        and line == vim.fn.line(".")
        and mark:match("%a") then -- select only letters
      vim.api.nvim_buf_set_mark(vim.api.nvim_get_current_buf(), mark, 0, 0, {})
      return
    end
  end
end

function GetNextSearchCount()
  local next = vim.fn.searchcount().current + 1
  if next > vim.fn.searchcount().total then
    return 1
  else
    return next
  end
end

function ChangeTabWidth(width)
  local curPos = vim.api.nvim_win_get_cursor(0)
  vim.opt_local.shiftwidth = width
  vim.api.nvim_input("gg=G")
  ExecuteAfter(500, function() vim.api.nvim_win_set_cursor(0, curPos) end)
end

function ShowPopup(text)
  local width = vim.fn.strdisplaywidth(text) + 2 -- works with utf8
  local height = 3
  local enterPopup = false

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),  -- center y
    col = math.floor((vim.o.columns - width) / 2), -- center x
    style = "minimal",
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
  }
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enterPopup, opts)

  -- Add text to popup
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "", " " .. text .. " ", "" })

  vim.defer_fn(function()
    -- try to close window
    pcall(vim.api.nvim_win_close, win, true)
  end, 1000)
end
