-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")

require('telescope').setup {
  defaults = {
    -- in telescope mappings
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<Tab>"] = actions.move_selection_previous, -- instead of select and next
        ["<S-Tab>"] = actions.move_selection_next,   -- instead of select and previous
      },
      n = {
        ["<Tab>"] = actions.move_selection_previous, -- instead of select and next
        ["<S-Tab>"] = actions.move_selection_next,   -- instead of select and previous
      }
    },
    layout_config = { preview_width = 0.6 } -- width as a percentage
  },
}
-- To setup file_browser after telescope is configured
require("telescope").load_extension "file_browser"
vim.api.nvim_set_keymap(
  "n",
  "<leader>bf",
  "<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
  { noremap = true, desc = "File browser" }
)

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")

vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Find existing buffers' })

-- Register the Search group (shown in which-key)
require("which-key").register({ s = { name = "Search" }, }, { prefix = "<leader>" })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

-- require ripgrep
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })


-- Remade builtin mark viewer
-- (to only show user marks)

local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values

local edited_builtin = {}

edited_builtin.usermarks = function(opts)
  local local_marks = {
    items = vim.fn.getmarklist(opts.bufnr),
    name_func = function(_, line)
      local textLine = vim.api.nvim_buf_get_lines(opts.bufnr, line - 1, line, false)[1]
      if textLine then
        textLine = textLine:match("[^%s].*$") -- remove trailing space
      end
      return textLine
    end,
  }
  local global_marks = {
    items = vim.fn.getmarklist(),
    name_func = function(mark, _)
      local fileName = vim.api.nvim_get_mark(mark, {})[4]
      if fileName then
        -- fileName = vim.fn.pathshorten(vim.fn.fnamemodify(fileName, ":~:h")) .. "/" .. vim.fn.fnamemodify(fileName, ':t') -- vim.fn.pathshorten(fileName, 1)
        -- local len = require('telescope.actions.state').get_current_picker(33).results_border.content_win_options.width - 16
        fileName = require("plenary.path"):new(fileName):normalize(vim.fn.expand("%:~:p"))
        local maxLen = 30
        if #fileName > maxLen then
          fileName = "…" .. string.sub(fileName, -(maxLen - 1))
        end
      end
      return fileName
    end,
  }
  local marks_table = {}
  local bufname = vim.api.nvim_buf_get_name(opts.bufnr)
  for _, cnf in ipairs { global_marks, local_marks } do
    for _, v in ipairs(cnf.items) do
      -- strip the first single quote character
      local mark = string.sub(v.mark, 2, 3)
      local _, lnum, col, _ = unpack(v.pos)
      local name = cnf.name_func(mark, lnum)
      -- same format to :marks command
      local line = string.format("%s %4d %s", mark, lnum, name)
      local row = {
        line = line,
        lnum = lnum,
        col = col,
        filename = v.file or bufname,
      }
      -- show only letters
      if mark:match("%a") then
        table.insert(marks_table, 1, row) -- insert at start (invert)
      end
    end
  end

  pickers
      .new(opts, {
        prompt_title = "User Marks",
        finder = finders.new_table {
          results = marks_table,
          entry_maker = opts.entry_maker or make_entry.gen_from_marks(opts),
        },
        previewer = conf.grep_previewer(opts),
        sorter = conf.generic_sorter(opts),
        push_cursor_on_edit = true,
        push_tagstack_on_edit = true,
        initial_mode = "insert",
      })
      :find()
end


local apply_config = function(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      local pickers_conf = require("telescope.config").pickers

      opts = opts or {}
      opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
      opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
      local pconf = pickers_conf[k] or {}
      local defaults = (function()
        if pconf.theme then
          return require("telescope.themes")["get_" .. pconf.theme](pconf)
        end
        return vim.deepcopy(pconf)
      end)()

      if pconf.mappings then
        defaults.attach_mappings = function(_, map)
          for mode, tbl in pairs(pconf.mappings) do
            for key, action in pairs(tbl) do
              map(mode, key, action)
            end
          end
          return true
        end
      end

      if pconf.attach_mappings and opts.attach_mappings then
        local opts_attach = opts.attach_mappings
        opts.attach_mappings = function(prompt_bufnr, map)
          pconf.attach_mappings(prompt_bufnr, map)
          return opts_attach(prompt_bufnr, map)
        end
      end

      v(vim.tbl_extend("force", defaults, opts))
    end
  end

  return mod
end

-- We can't do this in one statement because tree-sitter-lua docgen gets confused if we do
edited_builtin = apply_config(edited_builtin)




-- show marks
vim.keymap.set('n', '<leader>m', edited_builtin.usermarks, { desc = '[M]arks' })
