local dap = require("dap")
-- Install debugger with mason
require("mason-nvim-dap").setup({
  -- debugger list
  ensure_installed = {
    "python",
    "codelldb", -- C / C++ / Rust
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
--
-- Available variables
-- ${workspaceFolder} : current folder when opening neovim
-- ${fileDirname} : same
--

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb",
    args = { "--port", "${port}" },
  },
}


local codelldbConfig = {
  name = "Launch file",
  type = "codelldb",
  request = "launch",
  program = function()
    -- because vim.bo.filetype doesn't work here
    local fileName = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:t")
    local fileType = vim.filetype.match { filename = fileName }

    AutoCompile(true)
    -- Return executable path
    if fileType == "cpp"
        or fileType == "c" then
      return GetParentFolderPath() .. "/" .. GetParentFolderName()
    elseif fileType == "rust" then
      local executablePath = vim.fn.system("find '" ..
        GetParentFolderPath() .. "/../target/debug' -maxdepth 1 -type f -executable")
      return executablePath:sub(1, -2) -- remove the last '\n'
    end
  end,
  cwd = GetParentFolderPath()
  -- stopAtEntry = true, -- breakpoint at function start
}

-- Apply the config for all types
dap.configurations.cpp = { codelldbConfig }
dap.configurations.c = { codelldbConfig }
dap.configurations.rust = { codelldbConfig }

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
