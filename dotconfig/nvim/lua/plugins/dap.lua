local dap = require("dap")
-- Install debugger with mason
require("mason-nvim-dap").setup({
  -- debugger list
  ensure_installed = {
    "python",
    "cppdbg", -- C / C++
  },
  automatic_installation = true,
})


-- configure daps
-- require('dap-python').setup(vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python') -- doesn't use pip modules
require('dap-python').setup('/bin/python')
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
  },
}

-- C / C++ / Rust
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = vim.fn.stdpath("data") .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

local parentFolderName = vim.fn.fnamemodify("${fileDirname}", ":p:h:t")
local parentFolderPath = vim.fn.fnamemodify("${fileDirname}", ":p:h")

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      -- Compile with debug symbols (with -g)
      vim.fn.system("clang++ -g -c *.cpp && clang++ -g *.o -o " .. parentFolderName .. " ; rm *.o")
      return "${workspaceFolder}/" .. parentFolderName
    end,
    cwd = "${workspaceFolder}",
    -- stopAtEntry = true, -- better for debugging
  },
}

dap.configurations.c = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      -- Compile with debug symbols (with -g)
      vim.fn.system("clang -g -c *.c && clang *.o -lm -g -o " .. parentFolderName .. " ; rm *.o")
      return "${workspaceFolder}/" .. parentFolderName
    end,
    cwd = "${workspaceFolder}",
    -- stopAtEntry = true, -- better for debugging
  },
}


dap.configurations.rust = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      print(vim.fn.getcwd())
      vim.fn.system("cargo build") -- compile program first
      return vim.fn.system("find " .. parentFolderPath .. "/target/debug -maxdepth 1 -type f -executable")
    end,
    cwd = "${fileDirname}",
    -- stopAtEntry = true, -- better for debugging
  },
}

-- nice ui for debugging
local dapui = require("dapui")
dapui.setup({
  controls = { enabled = false }, -- hide clickable buttons
})


vim.fn.sign_define('DapBreakpoint', {
  text = '',
  texthl = 'DapBreakpoint',
  linehl = 'DapBreakpoint',
  numhl = 'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition',
  { text = "󰟃", texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

-- autoload dap ui when starting debugger
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

require("nvim-dap-virtual-text").setup({}) -- display inline values
