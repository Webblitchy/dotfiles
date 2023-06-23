-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<Tab>"] = actions.move_selection_next,       -- instead of select and next
        ["<S-Tab>"] = actions.move_selection_previous, -- instead of select and previous
      },
      n = {
        ["<Tab>"] = actions.move_selection_next,       -- instead of select and next
        ["<S-Tab>"] = actions.move_selection_previous, -- instead of select and previous
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
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Find existing buffers' })

vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

-- require ripgrep
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
