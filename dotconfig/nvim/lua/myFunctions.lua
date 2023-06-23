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

function GetBufferLSPs()
  return vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
end

function GetNullLsps()
  local nullLsps = {}
  for j, nullLsp in ipairs(require("null-ls").get_source({ filetype = vim.bo.filetype })) do
    nullLsps[j] = nullLsp.name
  end
  return table.concat(nullLsps, " | ")
end

function AutoCompile()
  local filePath = vim.api.nvim_buf_get_name(0) -- 0 for current buffer
  local fileType = vim.bo.filetype

  local workspacePath = nil --vim.lsp.buf.list_workspace_folders()[1] -- Not working
  if workspacePath == nil then
    workspacePath = vim.fn.fnamemodify(filePath, ":p:h")
  end

  local parentFolderName = vim.fn.fnamemodify(filePath, ":p:h:t")

  -- if there is space
  workspacePath = '"' .. workspacePath .. '"'
  parentFolderName = '"' .. parentFolderName .. '"'
  filePath = '"' .. filePath .. '"'

  local function executeFile(command)
    vim.api.nvim_command("term cd " .. workspacePath .. " && " .. command)
  end

  if fileType == "python"
      or fileType == "lua"
      or fileType == "java"
      or fileType == "scala"
      or fileType == "sage" then
    executeFile(fileType .. " " .. filePath)
  elseif fileType == "rust" then
    executeFile("cargo run")
  elseif fileType == "sh" then
    executeFile("bash < " .. filePath)
  elseif fileType == "javascript" then
    executeFile("node " .. filePath)
  elseif fileType == "c" then
    -- (always link math lib for simplicity)
    local compile = "clang -c *.c && clang *.o -lm -o " .. parentFolderName .. " ; rm *.o"
    executeFile(compile .. " && ./" .. parentFolderName)
  elseif fileType == "cpp" then
    local compile = "clang++ -c *.cpp && clang++ *.o -o " .. parentFolderName .. " ; rm *.o"
    executeFile(compile .. " && ./" .. parentFolderName)
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

function FormatOnSave()
  if not vim.lsp.buf.server_ready() then
    return
  end

  if vim.lsp.get_active_clients()[1].server_capabilities.documentFormattingProvider then -- can format with LSP
    local lspState = vim.lsp.util.get_progress_messages()[1]
    if lspState ~= nil then                                                              -- if has progress messages
      if not lspState.done then                                                          -- saying the server isn't ready
        return
      end
    end
    vim.lsp.buf.format({ async = false })                                                                           -- is async so it can save before quitting
  elseif #require("null-ls.sources").get_available(vim.bo.filetype, require("null-ls").methods.FORMATTING) > 0 then -- can format with null ls
    vim.lsp.buf.format({ async = false })                                                                           -- is async so it can save before quitting
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
