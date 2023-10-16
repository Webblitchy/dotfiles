-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('ibl').setup {
  indent = {
    char = '┊', -- ┆ ⁞ ┊ ⸽ |
  },
  scope = {
    show_start = false, -- disable underline start of scope
    show_end = false
  }
}
